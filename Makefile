NAME=$(basename $(notdir ${CURDIR}))
BUILD_ARGS = --build-arg REPO_BASE=${REPO_BASE} --build-arg HTTPS_PROXY=${HTTPS_PROXY}
# only add sgx related params if sgx device exists
ifneq ($(wildcard /dev/sgx_enclave),)
    sgx_dev_params =-v /dev/sgx_enclave:/dev/sgx/enclave -v /dev/sgx_provision:/dev/sgx/provision -v /var/run/aesmd:/var/run/aesmd
endif
docker-shell: docker-build
	docker run --rm -it ${sgx_dev_params} -e https_proxy=${HTTPS_PROXY} -v ${CURDIR}/:/${NAME}/ -w /${NAME} ${NAME} ${SHELL_CMD}
docker-build:
	docker build -t ${NAME} ${BUILD_ARGS} .
docker-benchmark:
	clear; (make docker-shell SHELL_CMD='make clean benchmark-all') 2>&1 | tee $@.log
wolfssl_ver ?= v5.7.6-stable
wolfssl_dir=__wolfssl_${wolfssl_ver}
wolfssl_examples_dir=__wolfssl_examples

WOLFSSL_ROOT=${CURDIR}/${wolfssl_dir}
WOLFSSL_LIB_IDE_SGX=${WOLFSSL_ROOT}/IDE/LINUX-SGX
benchmark-all: benchmark benchmark-intel benchmark-sgx benchmark-sgx-intel
benchmark: benchmark-build benchmark-run
benchmark-intel:
	WOLFSSL_CONFIG_ARGS='${WOLFSSL_CONFIG_ARGS_SGX}' make benchmark-build benchmark-run
benchmark-sgx: sgx-example-build-lib sgx-example-build sgx-example-bench
benchmark-sgx-intel:
	Wolfssl_C_Extra_Flags='${Wolfssl_C_Extra_Flags_Intel}' make benchmark-sgx

clean:
	rm -rf __*
setup:
	test -d ${wolfssl_dir} || git clone --depth 1 --branch ${wolfssl_ver} https://github.com/wolfSSL/wolfssl.git ${wolfssl_dir}
	test -d ${wolfssl_examples_dir} || git clone --depth 1 https://github.com/wolfSSL/wolfssl-examples.git ${wolfssl_examples_dir}
	test -f ${WOLFSSL_ROOT}/configure || (cd ${WOLFSSL_ROOT} && ./autogen.sh)
WOLFSSL_CONFIG_ARGS ?=
WOLFSSL_CONFIG_ARGS_SGX ?= --enable-intelasm --enable-aesni --enable-sp --enable-sp-asm --enable-sp-math
config:
	test -d ${WOLFSSL_ROOT} || make setup
	cd ${WOLFSSL_ROOT} && \
	./configure ${WOLFSSL_CONFIG_ARGS} && ./config.status
benchmark-build: config
	cd ${WOLFSSL_ROOT} && make
benchmark_args ?= -rsa_sign -ecc
benchmark-run:
	test -f ${WOLFSSL_ROOT}/wolfcrypt/benchmark/benchmark || make benchmark-build
	${WOLFSSL_ROOT}/wolfcrypt/benchmark/benchmark ${benchmark_args}

sgx-example: sgx-example-build sgx-example-test sgx-example-bench
wmmintrin_include_dir=/usr/lib/gcc/x86_64-redhat-linux/8/include
ifeq ($(wildcard ${wmmintrin_include_dir}),)
    wmmintrin_include_dir=/usr/lib/gcc/x86_64-amazon-linux/11/include
endif
Wolfssl_C_Extra_Flags ?= -DWOLFSSL_SGX
Wolfssl_C_Extra_Flags_Intel= -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I${wmmintrin_include_dir}
Wolfssl_C_Extra_Flags_Cmd_Update=sed -i 's|Wolfssl_C_Extra_Flags :=.*|Wolfssl_C_Extra_Flags := ${Wolfssl_C_Extra_Flags}|'
sgx-example-build-lib:
	test -d ${WOLFSSL_ROOT} || make setup
	cd ${WOLFSSL_ROOT}/IDE/LINUX-SGX && ./clean.sh && \
	git diff . | cat -n && \
	${Wolfssl_C_Extra_Flags_Cmd_Update} sgx_t_static.mk && \
	make -f sgx_t_static.mk HAVE_WOLFSSL_BENCHMARK=1 HAVE_WOLFSSL_TEST=1 HAVE_WOLFSSL_SP=1 && \
	ls -lah && test -f libwolfssl.sgx.static.lib.a
sgx-example-build:
	cd ${wolfssl_examples_dir}/SGX_Linux && \
	${Wolfssl_C_Extra_Flags_Cmd_Update} sgx_u.mk && ${Wolfssl_C_Extra_Flags_Cmd_Update} sgx_t.mk && \
	sed -i 's/sgx_tstdcxx/sgx_tstdc/' sgx_t.mk && \
	git diff . | cat -n && \
	rm -f ./App && make clean all SGX_MODE=SIM SGX_PRERELEASE=0 SGX_DEBUG=0 \
		SGX_WOLFSSL_LIB=${WOLFSSL_LIB_IDE_SGX} WOLFSSL_ROOT=${WOLFSSL_ROOT} \
		HAVE_WOLFSSL_TEST=' 1' HAVE_WOLFSSL_BENCHMARK=' 1' && \
	ls -lah && ./App
sgx-example-test:
		cd ${wolfssl_examples_dir}/SGX_Linux && ./App -t
sgx-example-bench:
	cd ${wolfssl_examples_dir}/SGX_Linux && ./App -b
