# Repo to benchmark wolfssl

# Run
```
make docker-shell
make benchmark # run benchmark in default mode 
make benchmark-intel # run benchmark with intel options
make benchmark-sgx # run benchmark with sgx libraries in simulaiton mode
make benchmark-sgx-intel # run benchmark with sgx libraries in simulaiton mode with intel options ( Build Fails )
```

# Full Logs
```bash
# make docker-benchmark
make[1]: Entering directory '/home/ec2-user/wolfssl_wolfcrypt/wolfcrypt_sgx_docker'
docker build -t wolfcrypt_sgx_docker --build-arg REPO_BASE= --build-arg HTTPS_PROXY= .
Sending build context to Docker daemon  9.728kB
Step 1/29 : ARG REPO_BASE
Step 2/29 : ARG IMG_BASE=oraclelinux:8.6
Step 3/29 : FROM ${REPO_BASE}docker.io/library/${IMG_BASE} AS base
 ---> 10bc1ae2798d
Step 4/29 : ARG HTTPS_PROXY
 ---> Using cache
 ---> 701ddb54386e
Step 5/29 : ENV http_proxy=$HTTPS_PROXY https_proxy=$HTTPS_PROXY HTTP_PROXY=$HTTPS_PROXY HTTPS_PROXY=$HTTPS_PROXY
 ---> Using cache
 ---> 979ff108569b
Step 6/29 : RUN echo "http_proxy=$HTTPS_PROXY https_proxy=$HTTPS_PROXY HTTP_PROXY=$HTTPS_PROXY HTTPS_PROXY=$HTTPS_PROXY"
 ---> Using cache
 ---> 180ddae58cd4
Step 7/29 : RUN curl https://google.com # test ssl
 ---> Using cache
 ---> 3d4222632568
Step 8/29 : FROM base AS sgx_sdk
 ---> 3d4222632568
Step 9/29 : RUN yum install -y make binutils
 ---> Using cache
 ---> 234a77f2bc7f
Step 10/29 : ARG SGX_SDK_SHORT=2.21
 ---> Using cache
 ---> 923d5c371aab
Step 11/29 : ARG SGX_SDK_DISTRO=rhel8.6-server
 ---> Using cache
 ---> b3924cbe5b12
Step 12/29 : ARG SGX_SDK_FULL=2.21.100.1
 ---> Using cache
 ---> 7f1bff1d44aa
Step 13/29 : ARG SGX_SDK_URL="https://download.01.org/intel-sgx/sgx-linux/${SGX_SDK_SHORT}/distro/${SGX_SDK_DISTRO}/sgx_linux_x64_sdk_${SGX_SDK_FULL}.bin"
 ---> Using cache
 ---> db78d556c30d
Step 14/29 : RUN echo ${SGX_SDK_URL} && curl -L ${SGX_SDK_URL} -o /tmp/sdk.bin && rm -rf /opt/intel/sgxsdk && printf "no\n/opt/intel\n" | sh /tmp/sdk.bin && rm -f /tmp/sdk.bin
 ---> Using cache
 ---> 14c7bc00bb69
Step 15/29 : FROM base AS sgx_rpm_rpeo
 ---> 3d4222632568
Step 16/29 : ARG SGX_SDK_SHORT=2.21
 ---> Using cache
 ---> 42f61b67de46
Step 17/29 : ARG SGX_SDK_DISTRO=rhel8.6-server
 ---> Using cache
 ---> 6d796dac834a
Step 18/29 : ARG SGX_RPM_REPO="https://download.01.org/intel-sgx/sgx-linux/${SGX_SDK_SHORT}/distro/${SGX_SDK_DISTRO}/sgx_rpm_local_repo.tgz"
 ---> Using cache
 ---> bec4e29a37d1
Step 19/29 : RUN mkdir -p /opt/intel && curl -sSL ${SGX_RPM_REPO} | tar -xzf - -C /opt/intel     && yum-config-manager --add-repo file:///opt/intel/sgx_rpm_local_repo
 ---> Using cache
 ---> afa3c25351e2
Step 20/29 : FROM base AS sgx_build_env
 ---> 3d4222632568
Step 21/29 : RUN yum install -y epel-release &&     yum groupinstall -y "Development Tools" --nobest &&      yum install -y git wget which llvm clang make vim
 ---> Using cache
 ---> eb969968d598
Step 22/29 : COPY --from=sgx_rpm_rpeo /opt/intel/sgx_rpm_local_repo /opt/intel/sgx_rpm_local_repo
 ---> Using cache
 ---> 4ef1e84f6081
Step 23/29 : RUN yum-config-manager --add-repo file:///opt/intel/sgx_rpm_local_repo &&     echo 'gpgcheck=0' >> /etc/yum.repos.d/opt_intel_sgx_rpm_local_repo.repo
 ---> Using cache
 ---> cf70d722e4cb
Step 24/29 : ARG SGX_RPM_PACKAGES="libsgx-enclave-common-devel libsgx-dcap-default-qpl-devel libsgx-dcap-ql-devel libsgx-dcap-quote-verify-devel libsgx-quote-ex-devel libsgx-launch-devel libsgx-urts-debuginfo"
 ---> Using cache
 ---> 6ce3f6f7f44e
Step 25/29 : RUN yum install --nogpgcheck -y ${SGX_RPM_PACKAGES}
 ---> Using cache
 ---> 88fd3ff41415
Step 26/29 : COPY --from=sgx_sdk /opt/intel/sgxsdk /opt/intel/sgxsdk
 ---> Using cache
 ---> 041258976a5c
Step 27/29 : ENV SGX_SDK=/opt/intel/sgxsdk CARGO_HOME=/root/.cargo RUSTUP_HOME=/root/.rustup
 ---> Using cache
 ---> 9689c882c995
Step 28/29 : ENV PATH=$PATH:$SGX_SDK/bin:$SGX_SDK/bin/x64:/root/.cargo/bin     LD_LIBRARY_PATH=$SGX_SDK/sdk_libs
 ---> Using cache
 ---> fde6c9a71aac
Step 29/29 : ENV http_proxy='' https_proxy='' HTTP_PROXY='' HTTPS_PROXY=''
 ---> Using cache
 ---> cd2fb980b6d3
Successfully built cd2fb980b6d3
Successfully tagged wolfcrypt_sgx_docker:latest
docker run --rm -it  -e https_proxy= -v /home/ec2-user/wolfssl_wolfcrypt/wolfcrypt_sgx_docker/:/wolfcrypt_sgx_docker/ -w /wolfcrypt_sgx_docker wolfcrypt_sgx_docker make clean benchmark-all
rm -rf *.log __*
test -d /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable || make setup
make[1]: Entering directory '/wolfcrypt_sgx_docker'
test -d __wolfssl_v5.7.6-stable || git clone --depth 1 --branch v5.7.6-stable https://github.com/wolfSSL/wolfssl.git __wolfssl_v5.7.6-stable
Cloning into '__wolfssl_v5.7.6-stable'...
remote: Enumerating objects: 3340, done.
remote: Counting objects: 100% (3340/3340), done.
remote: Compressing objects: 100% (2605/2605), done.
Receiving objects: 100% (3340/3340), 23.61 MiB | 16.13 MiB/s, done.
remote: Total 3340 (delta 881), reused 1981 (delta 594), pack-reused 0 (from 0)
Resolving deltas: 100% (881/881), done.
Note: switching to '239b85c80438bf60d9a5b9e0ebe9ff097a760d0d'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

test -d __wolfssl_examples || git clone --depth 1 https://github.com/wolfSSL/wolfssl-examples.git __wolfssl_examples
Cloning into '__wolfssl_examples'...
remote: Enumerating objects: 1371, done.
remote: Counting objects: 100% (1371/1371), done.
remote: Compressing objects: 100% (1078/1078), done.
remote: Total 1371 (delta 415), reused 862 (delta 252), pack-reused 0 (from 0)
Receiving objects: 100% (1371/1371), 3.52 MiB | 27.09 MiB/s, done.
Resolving deltas: 100% (415/415), done.
test -f /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/configure || (cd /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable && ./autogen.sh)
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, 'build-aux'.
libtoolize: copying file 'build-aux/ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'm4'.
libtoolize: copying file 'm4/libtool.m4'
libtoolize: copying file 'm4/ltoptions.m4'
libtoolize: copying file 'm4/ltsugar.m4'
libtoolize: copying file 'm4/ltversion.m4'
libtoolize: copying file 'm4/lt~obsolete.m4'
configure.ac:25: installing 'build-aux/compile'
configure.ac:27: installing 'build-aux/config.guess'
configure.ac:27: installing 'build-aux/config.sub'
configure.ac:31: installing 'build-aux/install-sh'
configure.ac:31: installing 'build-aux/missing'
Makefile.am: installing 'build-aux/depcomp'
parallel-tests: installing 'build-aux/test-driver'
make[1]: Leaving directory '/wolfcrypt_sgx_docker'
cd /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable && \
./configure  && ./config.status
checking whether to enable maintainer-specific portions of Makefiles... no
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking whether gcc understands -c and -o together... yes
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports the include directive... yes (GNU style)
checking whether make supports nested variables... yes
checking whether UID '0' is supported by ustar format... yes
checking whether GID '0' is supported by ustar format... yes
checking how to create a ustar tar archive... gnutar
checking dependency style of gcc... gcc3
checking whether make supports nested variables... (cached) yes
checking how to print strings... printf
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1966080
checking how to convert x86_64-pc-linux-gnu file names to x86_64-pc-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-pc-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for a working dd... /usr/bin/dd
checking how to truncate binary pipes... /usr/bin/dd bs=4096 count=1
checking for mt... no
checking if : is a manifest tool... no
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
checking whether the -Werror option is usable... yes
checking for simple visibility declarations... yes
checking size of long long... 8
checking size of long... 8
checking size of time_t... 8
checking for __uint128_t... yes
checking arpa/inet.h usability... yes
checking arpa/inet.h presence... yes
checking for arpa/inet.h... yes
checking fcntl.h usability... yes
checking fcntl.h presence... yes
checking for fcntl.h... yes
checking limits.h usability... yes
checking limits.h presence... yes
checking for limits.h... yes
checking netdb.h usability... yes
checking netdb.h presence... yes
checking for netdb.h... yes
checking netinet/in.h usability... yes
checking netinet/in.h presence... yes
checking for netinet/in.h... yes
checking stddef.h usability... yes
checking stddef.h presence... yes
checking for stddef.h... yes
checking time.h usability... yes
checking time.h presence... yes
checking for time.h... yes
checking sys/ioctl.h usability... yes
checking sys/ioctl.h presence... yes
checking for sys/ioctl.h... yes
checking sys/socket.h usability... yes
checking sys/socket.h presence... yes
checking for sys/socket.h... yes
checking sys/time.h usability... yes
checking sys/time.h presence... yes
checking for sys/time.h... yes
checking errno.h usability... yes
checking errno.h presence... yes
checking for errno.h... yes
checking sys/un.h usability... yes
checking sys/un.h presence... yes
checking for sys/un.h... yes
checking for socket in -lnetwork... no
checking whether byte ordering is bigendian... no
checking for __atomic... yes
checking stdatomic.h usability... yes
checking stdatomic.h presence... yes
checking for stdatomic.h... yes
checking for gethostbyname... yes
checking for getaddrinfo... yes
checking for gettimeofday... yes
checking for gmtime_r... yes
checking for gmtime_s... no
checking for inet_ntoa... yes
checking for memset... yes
checking for socket... yes
checking for strftime... yes
checking for atexit... yes
checking whether gethostbyname is declared... yes
checking whether getaddrinfo is declared... yes
checking whether gettimeofday is declared... yes
checking whether gmtime_r is declared... yes
checking whether gmtime_s is declared... no
checking whether inet_ntoa is declared... yes
checking whether memset is declared... yes
checking whether socket is declared... yes
checking whether strftime is declared... yes
checking whether atexit is declared... yes
checking for size_t... yes
checking for uint8_t... yes
checking for uintptr_t... yes
checking dependency style of gcc... gcc3
checking for thread local storage (TLS) class... _Thread_local
checking for debug... no
checking whether gcc is Clang... no
checking whether pthreads work with "-pthread" and "-lpthread"... yes
checking for joinable pthread attribute... PTHREAD_CREATE_JOINABLE
checking whether more special flags are required for pthreads... no
checking for PTHREAD_PRIO_INHERIT... yes
checking for cos in -lm... yes
checking for library containing gethostbyname... none required
checking for library containing socket... none required
checking for vcs system... git
checking for vcs checkout... yes
checking whether the linker accepts -Werror... yes
checking whether the linker accepts -z relro -z now... yes
checking whether the linker accepts -pie... yes
checking whether C compiler accepts -Werror... yes
checking whether C compiler accepts -Wno-pragmas... yes
checking whether C compiler accepts -Wall... yes
checking whether C compiler accepts -Wextra... yes
checking whether C compiler accepts -Wunknown-pragmas... yes
checking whether C compiler accepts -Wthis-test-should-fail... no
checking whether C compiler accepts --param=ssp-buffer-size=1... yes
checking whether C compiler accepts -Waddress... yes
checking whether C compiler accepts -Warray-bounds... yes
checking whether C compiler accepts -Wbad-function-cast... yes
checking whether C compiler accepts -Wchar-subscripts... yes
checking whether C compiler accepts -Wcomment... yes
checking whether C compiler accepts -Wfloat-equal... yes
checking whether C compiler accepts -Wformat-security... yes
checking whether C compiler accepts -Wformat=2... yes
checking whether C compiler accepts -Wmaybe-uninitialized... yes
checking whether C compiler accepts -Wmissing-field-initializers... yes
checking whether C compiler accepts -Wmissing-noreturn... yes
checking whether C compiler accepts -Wmissing-prototypes... yes
checking whether C compiler accepts -Wnested-externs... yes
checking whether C compiler accepts -Wnormalized=id... yes
checking whether C compiler accepts -Woverride-init... yes
checking whether C compiler accepts -Wpointer-arith... yes
checking whether C compiler accepts -Wpointer-sign... yes
checking whether C compiler accepts -Wshadow... yes
checking whether C compiler accepts -Wshorten-64-to-32... no
checking whether C compiler accepts -Wsign-compare... yes
checking whether C compiler accepts -Wstrict-overflow=1... yes
checking whether C compiler accepts -Wstrict-prototypes... no
checking whether C compiler accepts -Wswitch-enum... yes
checking whether C compiler accepts -Wundef... yes
checking whether C compiler accepts -Wunused... yes
checking whether C compiler accepts -Wunused-result... yes
checking whether C compiler accepts -Wunused-variable... yes
checking whether C compiler accepts -Wwrite-strings... yes
checking whether C compiler accepts -fwrapv... yes
creating wolfssl-config - generic 5.7.6 for -lwolfssl -lpthread
checking the number of available CPUs... 4
configure: adding automake macro support
configure: creating aminclude.am
configure: added jobserver support to make for 5 jobs
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating stamp-h
config.status: creating Makefile
config.status: creating wolfssl/version.h
config.status: creating wolfssl/options.h
config.status: creating support/wolfssl.pc
config.status: creating debian/control
config.status: creating debian/changelog
config.status: creating rpm/spec
config.status: creating wolfcrypt/test/test_paths.h
config.status: creating scripts/unit.test
config.status: creating config.h
config.status: executing depfiles commands
config.status: executing libtool commands
config.status: executing wolfssl/wolfcrypt/async.h commands
config.status: executing wolfssl/wolfcrypt/fips.h commands
config.status: executing wolfssl/wolfcrypt/port/cavium/cavium_nitrox.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist_mem.h commands
configure: ---
configure: Running make clean...
configure: ---
configure: Generating user options header...
---
Configuration summary for wolfssl version 5.7.6

   * Installation prefix:        /usr/local
   * System type:                pc-linux-gnu
   * Host CPU:                   x86_64
   * C Compiler:                 gcc
   * C Flags:                       -Werror -Wno-pragmas -Wall -Wextra -Wunknown-pragmas --param=ssp-buffer-size=1 -Waddress -Warray-bounds -Wbad-function-cast -Wchar-subscripts -Wcomment -Wfloat-equal -Wformat-security -Wformat=2 -Wmaybe-uninitialized -Wmissing-field-initializers -Wmissing-noreturn -Wmissing-prototypes -Wnested-externs -Wnormalized=id -Woverride-init -Wpointer-arith -Wpointer-sign -Wshadow -Wsign-compare -Wstrict-overflow=1 -Wswitch-enum -Wundef -Wunused -Wunused-result -Wunused-variable -Wwrite-strings -fwrapv
   * C++ Compiler:
   * C++ Flags:
   * CPP Flags:
   * CCAS Flags:
   * LD Flags:
   * LIB Flags:                   -pie -z relro -z now -Werror
   * Library Suffix:
   * Debug enabled:              no
   * Coverage enabled:
   * Warnings as failure:        yes
   * make -j:                    5
   * VCS checkout:               yes

   Features
   * Experimental settings:      Forbidden
   * FIPS:                       no
   * Single threaded:            no
   * Filesystem:                 yes
   * OpenSSH Build:              no
   * OpenSSL Extra API:          no
   * OpenSSL Coexist:            no
   * Old Names:                  yes
   * Max Strength Build:         no
   * Distro Build:               no
   * Reproducible Build:         no
   * Side-channel Hardening:     yes
   * Single Precision Math:      no
   * SP implementation:          all
   * Fast Math:                  no
   * Heap Math:                  no
   * Assembly Allowed:           yes
   * sniffer:                    no
   * snifftest:                  no
   * ARC4:                       no
   * AES:                        yes
   * AES-NI:                     no
   * AES-CBC:                    yes
   * AES-CBC length checks:      no
   * AES-GCM:                    yes
   * AES-GCM streaming:          no
   * AES-CCM:                    no
   * AES-CTR:                    no
   * AES-CFB:                    no
   * AES-OFB:                    no
   * AES-XTS:                    no
   * AES-XTS streaming:          no
   * AES-SIV:                    no
   * AES-EAX:                    no
   * AES Bitspliced:             no
   * AES Key Wrap:               no
   * ARIA:                       no
   * DES3:                       no
   * DES3 TLS Suites:            no
   * Camellia:                   no
   * CUDA:                       no
   * SM4-ECB:                    no
   * SM4-CBC:                    no
   * SM4-CTR:                    no
   * SM4-GCM:                    no
   * SM4-CCM:                    no
   * NULL Cipher:                no
   * MD2:                        no
   * MD4:                        no
   * MD5:                        yes
   * RIPEMD:                     no
   * SHA:                        yes
   * SHA-224:                    yes
   * SHA-384:                    yes
   * SHA-512:                    yes
   * SHA3:                       yes
   * SHAKE128:                   no
   * SHAKE256:                   no
   * SM3:                        no
   * BLAKE2:                     no
   * BLAKE2S:                    no
   * SipHash:                    no
   * CMAC:                       no
   * keygen:                     no
   * acert:                      no
   * certgen:                    no
   * certreq:                    no
   * certext:                    no
   * certgencache:               no
   * CHACHA:                     yes
   * XCHACHA:                    no
   * Hash DRBG:                  yes
   * MmemUse Entropy:
   * (AKA: wolfEntropy):         no
   * PWDBASED:                   yes
   * Encrypted keys:             no
   * scrypt:                     no
   * wolfCrypt Only:             no
   * HKDF:                       yes
   * HPKE:                       no
   * X9.63 KDF:                  no
   * SRTP-KDF:                   no
   * PSK:                        no
   * Poly1305:                   yes
   * LEANPSK:                    no
   * LEANTLS:                    no
   * RSA:                        yes
   * RSA-PSS:                    yes
   * DSA:                        no
   * DH:                         yes
   * DH Default Parameters:      yes
   * ECC:                        yes
   * ECC Custom Curves:          no
   * ECC Minimum Bits:           224
   * FPECC:                      no
   * ECC_ENCRYPT:                no
   * Brainpool:                  no
   * SM2:                        no
   * CURVE25519:                 no
   * ED25519:                    no
   * ED25519 streaming:          no
   * CURVE448:                   no
   * ED448:                      no
   * ED448 streaming:            no
   * LMS:                        no
   * LMS wolfSSL impl:           no
   * XMSS:                       no
   * XMSS wolfSSL impl:          no
   * KYBER:                      no
   * KYBER wolfSSL impl:         no
   * DILITHIUM:                  no
   * ECCSI                       no
   * SAKKE                       no
   * ASN:                        yes
   * Anonymous cipher:           no
   * CODING:                     yes
   * MEMORY:                     yes
   * I/O POOL:                   no
   * wolfSentry:                 no
   * LIGHTY:                     no
   * WPA Supplicant:             no
   * HAPROXY:                    no
   * STUNNEL:                    no
   * tcpdump:                    no
   * libssh2:                    no
   * ntp:                        no
   * rsyslog:                    no
   * Apache httpd:               no
   * NGINX:                      no
   * OpenResty:                  no
   * ASIO:                       no
   * LIBWEBSOCKETS:              no
   * Qt:                         no
   * Qt Unit Testing:            no
   * SIGNAL:                     no
   * chrony:                     no
   * strongSwan:                 no
   * OpenLDAP:                   no
   * hitch:                      no
   * memcached:                  no
   * Mosquitto                   no
   * ERROR_STRINGS:              yes
   * DTLS:                       no
   * DTLS v1.3:                  no
   * SCTP:                       no
   * SRTP:                       no
   * Indefinite Length:          no
   * Multicast:                  no
   * SSL v3.0 (Old):             no
   * TLS v1.0 (Old):             no
   * TLS v1.1 (Old):             no
   * TLS v1.2:                   yes
   * TLS v1.3:                   yes
   * RPK:                        no
   * Post-handshake Auth:        no
   * Early Data:                 no
   * QUIC:                       no
   * Send State in HRR Cookie:   undefined
   * OCSP:                       no
   * OCSP Stapling:              no
   * OCSP Stapling v2:           no
   * CRL:                        no
   * CRL-MONITOR:                no
   * Persistent session cache:   no
   * Persistent cert    cache:   no
   * Atomic User Record Layer:   no
   * Public Key Callbacks:       no
   * libxmss:                    no
   * liblms:                     no
   * liboqs:                     no
   * Whitewood netRandom:        no
   * Server Name Indication:     yes
   * ALPN:                       no
   * Maximum Fragment Length:    no
   * Trusted CA Indication:      no
   * Truncated HMAC:             no
   * Supported Elliptic Curves:  yes
   * FFDHE only in client:       no
   * Session Ticket:             no
   * Extended Master Secret:     yes
   * Renegotiation Indication:   no
   * Secure Renegotiation:       no
   * Fallback SCSV:              no
   * Keying Material Exporter:   no
   * All TLS Extensions:         no
   * S/MIME:                     no
   * PKCS#7:                     no
   * PKCS#8:                     yes
   * PKCS#11:                    no
   * PKCS#12:                    yes
   * wolfSSH:                    no
   * wolfEngine:                 no
   * wolfTPM:                    no
   * wolfCLU:                    no
   * wolfSCEP:                   no
   * Secure Remote Password:     no
   * Small Stack:                no
   * Linux Kernel Module:        no
   * valgrind unit tests:        no
   * LIBZ:                       no
   * Examples:                   yes
   * Crypt tests:                yes
   * Stack sizes in tests:       no
   * Heap stats in tests:        no
   * Asynchronous Crypto:        no
   * Asynchronous Crypto (sim):  no
   * Cavium Nitrox:              no
   * Cavium Octeon (Sync):       no
   * Intel Quick Assist:         no
   * ARM ASM:                    no
   * ARM ASM SHA512/SHA3 Crypto  no
   * ARM ASM SM3/SM4 Crypto      no
   * RISC-V ASM                  no
   * Write duplicate:            no
   * Xilinx Hardware Acc.:       no
   * C89:                        no
   * Inline Code:                yes
   * Linux AF_ALG:               no
   * Linux KCAPI:                no
   * Linux devcrypto:            no
   * PK callbacks:               no
   * Crypto callbacks:           no
   * i.MX CAAM:                  no
   * IoT-Safe:                   no
   * IoT-Safe HWRNG:             no
   * NXP SE050:                  no
   * Maxim Integrated MAXQ10XX:  no
   * PSA:                        no
   * System CA certs:            yes
   * Dual alg cert support:      no
   * ERR Queues per Thread:      yes
   * rwlock:                     no
   * keylog export:              no
   * AutoSAR :                   no

---
./configure flags:
---
Note: Make sure your application includes "wolfssl/options.h" before any other wolfSSL headers.
      You can define "WOLFSSL_USE_OPTIONS_H" in your application to include this automatically.
config.status: creating stamp-h
config.status: creating Makefile
config.status: creating wolfssl/version.h
config.status: creating wolfssl/options.h
config.status: creating support/wolfssl.pc
config.status: creating debian/control
config.status: creating debian/changelog
config.status: creating rpm/spec
config.status: creating wolfcrypt/test/test_paths.h
config.status: creating scripts/unit.test
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands
config.status: executing wolfssl/wolfcrypt/async.h commands
config.status: executing wolfssl/wolfcrypt/fips.h commands
config.status: executing wolfssl/wolfcrypt/port/cavium/cavium_nitrox.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist_mem.h commands
cd /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable && make
make[1]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make -j5  all-recursive
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[3]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[3]: warning: -j5 forced in submake: resetting jobserver mode.
  CC       wolfcrypt/test/testsuite_testsuite_test-test.o
  CC       examples/client/testsuite_testsuite_test-client.o
  CC       examples/echoserver/testsuite_testsuite_test-echoserver.o
  CC       examples/echoclient/testsuite_testsuite_test-echoclient.o
  CC       examples/server/testsuite_testsuite_test-server.o
  CC       examples/client/tests_unit_test-client.o
  CC       examples/server/tests_unit_test-server.o
  CC       wolfcrypt/benchmark/benchmark.o
  CC       wolfcrypt/src/src_libwolfssl_la-hmac.lo
  CC       wolfcrypt/src/src_libwolfssl_la-hash.lo
  CC       wolfcrypt/src/src_libwolfssl_la-cpuid.lo
  CC       wolfcrypt/src/src_libwolfssl_la-kdf.lo
  CC       wolfcrypt/src/src_libwolfssl_la-random.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha256.lo
  CC       wolfcrypt/src/src_libwolfssl_la-rsa.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sp_int.lo
  CC       wolfcrypt/src/src_libwolfssl_la-aes.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha512.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha3.lo
  CC       wolfcrypt/src/src_libwolfssl_la-logging.lo
  CC       wolfcrypt/src/src_libwolfssl_la-wc_port.lo
  CC       wolfcrypt/src/src_libwolfssl_la-error.lo
  CC       wolfcrypt/src/src_libwolfssl_la-wc_encrypt.lo
  CC       wolfcrypt/src/src_libwolfssl_la-signature.lo
  CC       wolfcrypt/src/src_libwolfssl_la-wolfmath.lo
  CC       wolfcrypt/src/src_libwolfssl_la-memory.lo
  CC       wolfcrypt/src/src_libwolfssl_la-dh.lo
  CC       wolfcrypt/src/src_libwolfssl_la-asn.lo
  CC       wolfcrypt/src/src_libwolfssl_la-coding.lo
  CC       wolfcrypt/src/src_libwolfssl_la-poly1305.lo
  CC       wolfcrypt/src/src_libwolfssl_la-md5.lo
  CC       wolfcrypt/src/src_libwolfssl_la-pwdbased.lo
  CC       wolfcrypt/src/src_libwolfssl_la-pkcs12.lo
  CC       wolfcrypt/src/src_libwolfssl_la-chacha.lo
  CC       wolfcrypt/src/src_libwolfssl_la-chacha20_poly1305.lo
  CC       wolfcrypt/src/src_libwolfssl_la-ecc.lo
  CC       src/libwolfssl_la-internal.lo
  CC       src/libwolfssl_la-wolfio.lo
  CC       src/libwolfssl_la-keys.lo
  CC       src/libwolfssl_la-ssl.lo
  CC       src/libwolfssl_la-tls.lo
  CC       src/libwolfssl_la-tls13.lo
  CC       wolfcrypt/test/test.o
  CC       examples/benchmark/tls_bench.o
  CC       examples/client/client-client.o
  CC       examples/echoclient/echoclient.o
  CC       examples/echoserver/echoserver.o
  CC       examples/server/server-server.o
  CC       examples/asn1/asn1.o
  CC       examples/pem/pem.o
  CC       testsuite/testsuite_test-testsuite.o
  CC       tests/unit_test-unit.o
  CC       tests/unit_test-api.o
  CC       tests/unit_test-suites.o
  CC       tests/unit_test-hash.o
  CC       tests/unit_test-w64wrapper.o
  CC       tests/unit_test-srp.o
  CC       tests/unit_test-quic.o
  CCLD     src/libwolfssl.la
  CCLD     wolfcrypt/benchmark/benchmark
  CCLD     examples/benchmark/tls_bench
  CCLD     examples/client/client
  CCLD     examples/echoclient/echoclient
  CCLD     examples/echoserver/echoserver
  CCLD     examples/server/server
  CCLD     examples/asn1/asn1
  CCLD     examples/pem/pem
  CCLD     testsuite/testsuite.test
  CCLD     wolfcrypt/test/testwolfcrypt
  CCLD     tests/unit.test
make[3]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[1]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
test -f /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark || make benchmark-build
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark -rsa_sign -ecc
------------------------------------------------------------------------------
 wolfSSL version 5.7.6
------------------------------------------------------------------------------
Math:   Multi-Precision: Wolf(SP) word-size=64 bits=4096 sp_int.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
ECDHE [      SECP256R1]   256    agree      1900 ops took 1.053 sec, avg 0.554 ms, 1803.788 ops/sec
ECDSA [      SECP256R1]   256     sign      1600 ops took 1.058 sec, avg 0.661 ms, 1512.309 ops/sec
ECDSA [      SECP256R1]   256   verify      2100 ops took 1.016 sec, avg 0.484 ms, 2066.795 ops/sec
Benchmark complete
WOLFSSL_CONFIG_ARGS='--enable-intelasm --enable-aesni --enable-sp --enable-sp-asm --enable-sp-math' make benchmark-build benchmark-run
make[1]: Entering directory '/wolfcrypt_sgx_docker'
test -d /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable || make setup
cd /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable && \
./configure --enable-intelasm --enable-aesni --enable-sp --enable-sp-asm --enable-sp-math && ./config.status
checking whether to enable maintainer-specific portions of Makefiles... no
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking whether gcc understands -c and -o together... yes
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports the include directive... yes (GNU style)
checking whether make supports nested variables... yes
checking whether UID '0' is supported by ustar format... yes
checking whether GID '0' is supported by ustar format... yes
checking how to create a ustar tar archive... gnutar
checking dependency style of gcc... gcc3
checking whether make supports nested variables... (cached) yes
checking how to print strings... printf
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1966080
checking how to convert x86_64-pc-linux-gnu file names to x86_64-pc-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-pc-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for a working dd... /usr/bin/dd
checking how to truncate binary pipes... /usr/bin/dd bs=4096 count=1
checking for mt... no
checking if : is a manifest tool... no
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
checking whether the -Werror option is usable... yes
checking for simple visibility declarations... yes
checking size of long long... 8
checking size of long... 8
checking size of time_t... 8
checking for __uint128_t... yes
checking arpa/inet.h usability... yes
checking arpa/inet.h presence... yes
checking for arpa/inet.h... yes
checking fcntl.h usability... yes
checking fcntl.h presence... yes
checking for fcntl.h... yes
checking limits.h usability... yes
checking limits.h presence... yes
checking for limits.h... yes
checking netdb.h usability... yes
checking netdb.h presence... yes
checking for netdb.h... yes
checking netinet/in.h usability... yes
checking netinet/in.h presence... yes
checking for netinet/in.h... yes
checking stddef.h usability... yes
checking stddef.h presence... yes
checking for stddef.h... yes
checking time.h usability... yes
checking time.h presence... yes
checking for time.h... yes
checking sys/ioctl.h usability... yes
checking sys/ioctl.h presence... yes
checking for sys/ioctl.h... yes
checking sys/socket.h usability... yes
checking sys/socket.h presence... yes
checking for sys/socket.h... yes
checking sys/time.h usability... yes
checking sys/time.h presence... yes
checking for sys/time.h... yes
checking errno.h usability... yes
checking errno.h presence... yes
checking for errno.h... yes
checking sys/un.h usability... yes
checking sys/un.h presence... yes
checking for sys/un.h... yes
checking for socket in -lnetwork... no
checking whether byte ordering is bigendian... no
checking for __atomic... yes
checking stdatomic.h usability... yes
checking stdatomic.h presence... yes
checking for stdatomic.h... yes
checking for gethostbyname... yes
checking for getaddrinfo... yes
checking for gettimeofday... yes
checking for gmtime_r... yes
checking for gmtime_s... no
checking for inet_ntoa... yes
checking for memset... yes
checking for socket... yes
checking for strftime... yes
checking for atexit... yes
checking whether gethostbyname is declared... yes
checking whether getaddrinfo is declared... yes
checking whether gettimeofday is declared... yes
checking whether gmtime_r is declared... yes
checking whether gmtime_s is declared... no
checking whether inet_ntoa is declared... yes
checking whether memset is declared... yes
checking whether socket is declared... yes
checking whether strftime is declared... yes
checking whether atexit is declared... yes
checking for size_t... yes
checking for uint8_t... yes
checking for uintptr_t... yes
checking dependency style of gcc... gcc3
checking for thread local storage (TLS) class... _Thread_local
checking for debug... no
checking whether gcc is Clang... no
checking whether pthreads work with "-pthread" and "-lpthread"... yes
checking for joinable pthread attribute... PTHREAD_CREATE_JOINABLE
checking whether more special flags are required for pthreads... no
checking for PTHREAD_PRIO_INHERIT... yes
checking for cos in -lm... yes
checking for library containing gethostbyname... none required
checking for library containing socket... none required
checking for vcs system... git
checking for vcs checkout... yes
checking whether the linker accepts -Werror... yes
checking whether the linker accepts -z relro -z now... yes
checking whether the linker accepts -pie... yes
checking whether C compiler accepts -Werror... yes
checking whether C compiler accepts -Wno-pragmas... yes
checking whether C compiler accepts -Wall... yes
checking whether C compiler accepts -Wextra... yes
checking whether C compiler accepts -Wunknown-pragmas... yes
checking whether C compiler accepts -Wthis-test-should-fail... no
checking whether C compiler accepts --param=ssp-buffer-size=1... yes
checking whether C compiler accepts -Waddress... yes
checking whether C compiler accepts -Warray-bounds... yes
checking whether C compiler accepts -Wbad-function-cast... yes
checking whether C compiler accepts -Wchar-subscripts... yes
checking whether C compiler accepts -Wcomment... yes
checking whether C compiler accepts -Wfloat-equal... yes
checking whether C compiler accepts -Wformat-security... yes
checking whether C compiler accepts -Wformat=2... yes
checking whether C compiler accepts -Wmaybe-uninitialized... yes
checking whether C compiler accepts -Wmissing-field-initializers... yes
checking whether C compiler accepts -Wmissing-noreturn... yes
checking whether C compiler accepts -Wmissing-prototypes... yes
checking whether C compiler accepts -Wnested-externs... yes
checking whether C compiler accepts -Wnormalized=id... yes
checking whether C compiler accepts -Woverride-init... yes
checking whether C compiler accepts -Wpointer-arith... yes
checking whether C compiler accepts -Wpointer-sign... yes
checking whether C compiler accepts -Wshadow... yes
checking whether C compiler accepts -Wshorten-64-to-32... no
checking whether C compiler accepts -Wsign-compare... yes
checking whether C compiler accepts -Wstrict-overflow=1... yes
checking whether C compiler accepts -Wstrict-prototypes... no
checking whether C compiler accepts -Wswitch-enum... yes
checking whether C compiler accepts -Wundef... yes
checking whether C compiler accepts -Wunused... yes
checking whether C compiler accepts -Wunused-result... yes
checking whether C compiler accepts -Wunused-variable... yes
checking whether C compiler accepts -Wwrite-strings... yes
checking whether C compiler accepts -fwrapv... yes
creating wolfssl-config - generic 5.7.6 for -lwolfssl -lpthread
checking the number of available CPUs... 4
configure: adding automake macro support
configure: creating aminclude.am
configure: added jobserver support to make for 5 jobs
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating stamp-h
config.status: creating Makefile
config.status: creating wolfssl/version.h
config.status: creating wolfssl/options.h
config.status: creating support/wolfssl.pc
config.status: creating debian/control
config.status: creating debian/changelog
config.status: creating rpm/spec
config.status: creating wolfcrypt/test/test_paths.h
config.status: creating scripts/unit.test
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands
config.status: executing wolfssl/wolfcrypt/async.h commands
config.status: executing wolfssl/wolfcrypt/fips.h commands
config.status: executing wolfssl/wolfcrypt/port/cavium/cavium_nitrox.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist_mem.h commands
configure: ---
configure: Running make clean...
configure: ---
configure: Generating user options header...
---
Configuration summary for wolfssl version 5.7.6

   * Installation prefix:        /usr/local
   * System type:                pc-linux-gnu
   * Host CPU:                   x86_64
   * C Compiler:                 gcc
   * C Flags:                       -Werror -Wno-pragmas -Wall -Wextra -Wunknown-pragmas --param=ssp-buffer-size=1 -Waddress -Warray-bounds -Wbad-function-cast -Wchar-subscripts -Wcomment -Wfloat-equal -Wformat-security -Wformat=2 -Wmaybe-uninitialized -Wmissing-field-initializers -Wmissing-noreturn -Wmissing-prototypes -Wnested-externs -Wnormalized=id -Woverride-init -Wpointer-arith -Wpointer-sign -Wshadow -Wsign-compare -Wstrict-overflow=1 -Wswitch-enum -Wundef -Wunused -Wunused-result -Wunused-variable -Wwrite-strings -fwrapv
   * C++ Compiler:
   * C++ Flags:
   * CPP Flags:
   * CCAS Flags:
   * LD Flags:
   * LIB Flags:                   -pie -z relro -z now -Werror
   * Library Suffix:
   * Debug enabled:              no
   * Coverage enabled:
   * Warnings as failure:        yes
   * make -j:                    5
   * VCS checkout:               yes

   Features
   * Experimental settings:      Forbidden
   * FIPS:                       no
   * Single threaded:            no
   * Filesystem:                 yes
   * OpenSSH Build:              no
   * OpenSSL Extra API:          no
   * OpenSSL Coexist:            no
   * Old Names:                  yes
   * Max Strength Build:         no
   * Distro Build:               no
   * Reproducible Build:         no
   * Side-channel Hardening:     yes
   * Single Precision Math:      yes
   * SP implementation:          restricted
   * Fast Math:                  no
   * Heap Math:                  no
   * Assembly Allowed:           yes
   * sniffer:                    no
   * snifftest:                  no
   * ARC4:                       no
   * AES:                        yes
   * AES-NI:                     yes
   * AES-CBC:                    yes
   * AES-CBC length checks:      no
   * AES-GCM:                    yes
   * AES-GCM streaming:          no
   * AES-CCM:                    no
   * AES-CTR:                    no
   * AES-CFB:                    no
   * AES-OFB:                    no
   * AES-XTS:                    no
   * AES-XTS streaming:          no
   * AES-SIV:                    no
   * AES-EAX:                    no
   * AES Bitspliced:             no
   * AES Key Wrap:               no
   * ARIA:                       no
   * DES3:                       no
   * DES3 TLS Suites:            no
   * Camellia:                   no
   * CUDA:                       no
   * SM4-ECB:                    no
   * SM4-CBC:                    no
   * SM4-CTR:                    no
   * SM4-GCM:                    no
   * SM4-CCM:                    no
   * NULL Cipher:                no
   * MD2:                        no
   * MD4:                        no
   * MD5:                        yes
   * RIPEMD:                     no
   * SHA:                        yes
   * SHA-224:                    yes
   * SHA-384:                    yes
   * SHA-512:                    yes
   * SHA3:                       yes
   * SHAKE128:                   no
   * SHAKE256:                   no
   * SM3:                        no
   * BLAKE2:                     no
   * BLAKE2S:                    no
   * SipHash:                    no
   * CMAC:                       no
   * keygen:                     no
   * acert:                      no
   * certgen:                    no
   * certreq:                    no
   * certext:                    no
   * certgencache:               no
   * CHACHA:                     yes
   * XCHACHA:                    no
   * Hash DRBG:                  yes
   * MmemUse Entropy:
   * (AKA: wolfEntropy):         no
   * PWDBASED:                   yes
   * Encrypted keys:             no
   * scrypt:                     no
   * wolfCrypt Only:             no
   * HKDF:                       yes
   * HPKE:                       no
   * X9.63 KDF:                  no
   * SRTP-KDF:                   no
   * PSK:                        no
   * Poly1305:                   yes
   * LEANPSK:                    no
   * LEANTLS:                    no
   * RSA:                        yes
   * RSA-PSS:                    yes
   * DSA:                        no
   * DH:                         yes
   * DH Default Parameters:      yes
   * ECC:                        yes
   * ECC Custom Curves:          no
   * ECC Minimum Bits:           224
   * FPECC:                      no
   * ECC_ENCRYPT:                no
   * Brainpool:                  no
   * SM2:                        no
   * CURVE25519:                 no
   * ED25519:                    no
   * ED25519 streaming:          no
   * CURVE448:                   no
   * ED448:                      no
   * ED448 streaming:            no
   * LMS:                        no
   * LMS wolfSSL impl:           no
   * XMSS:                       no
   * XMSS wolfSSL impl:          no
   * KYBER:                      no
   * KYBER wolfSSL impl:         no
   * DILITHIUM:                  no
   * ECCSI                       no
   * SAKKE                       no
   * ASN:                        yes
   * Anonymous cipher:           no
   * CODING:                     yes
   * MEMORY:                     yes
   * I/O POOL:                   no
   * wolfSentry:                 no
   * LIGHTY:                     no
   * WPA Supplicant:             no
   * HAPROXY:                    no
   * STUNNEL:                    no
   * tcpdump:                    no
   * libssh2:                    no
   * ntp:                        no
   * rsyslog:                    no
   * Apache httpd:               no
   * NGINX:                      no
   * OpenResty:                  no
   * ASIO:                       no
   * LIBWEBSOCKETS:              no
   * Qt:                         no
   * Qt Unit Testing:            no
   * SIGNAL:                     no
   * chrony:                     no
   * strongSwan:                 no
   * OpenLDAP:                   no
   * hitch:                      no
   * memcached:                  no
   * Mosquitto                   no
   * ERROR_STRINGS:              yes
   * DTLS:                       no
   * DTLS v1.3:                  no
   * SCTP:                       no
   * SRTP:                       no
   * Indefinite Length:          no
   * Multicast:                  no
   * SSL v3.0 (Old):             no
   * TLS v1.0 (Old):             no
   * TLS v1.1 (Old):             no
   * TLS v1.2:                   yes
   * TLS v1.3:                   yes
   * RPK:                        no
   * Post-handshake Auth:        no
   * Early Data:                 no
   * QUIC:                       no
   * Send State in HRR Cookie:   undefined
   * OCSP:                       no
   * OCSP Stapling:              no
   * OCSP Stapling v2:           no
   * CRL:                        no
   * CRL-MONITOR:                no
   * Persistent session cache:   no
   * Persistent cert    cache:   no
   * Atomic User Record Layer:   no
   * Public Key Callbacks:       no
   * libxmss:                    no
   * liblms:                     no
   * liboqs:                     no
   * Whitewood netRandom:        no
   * Server Name Indication:     yes
   * ALPN:                       no
   * Maximum Fragment Length:    no
   * Trusted CA Indication:      no
   * Truncated HMAC:             no
   * Supported Elliptic Curves:  yes
   * FFDHE only in client:       no
   * Session Ticket:             no
   * Extended Master Secret:     yes
   * Renegotiation Indication:   no
   * Secure Renegotiation:       no
   * Fallback SCSV:              no
   * Keying Material Exporter:   no
   * All TLS Extensions:         no
   * S/MIME:                     no
   * PKCS#7:                     no
   * PKCS#8:                     yes
   * PKCS#11:                    no
   * PKCS#12:                    yes
   * wolfSSH:                    no
   * wolfEngine:                 no
   * wolfTPM:                    no
   * wolfCLU:                    no
   * wolfSCEP:                   no
   * Secure Remote Password:     no
   * Small Stack:                no
   * Linux Kernel Module:        no
   * valgrind unit tests:        no
   * LIBZ:                       no
   * Examples:                   yes
   * Crypt tests:                yes
   * Stack sizes in tests:       no
   * Heap stats in tests:        no
   * Asynchronous Crypto:        no
   * Asynchronous Crypto (sim):  no
   * Cavium Nitrox:              no
   * Cavium Octeon (Sync):       no
   * Intel Quick Assist:         no
   * ARM ASM:                    no
   * ARM ASM SHA512/SHA3 Crypto  no
   * ARM ASM SM3/SM4 Crypto      no
   * RISC-V ASM                  no
   * Write duplicate:            no
   * Xilinx Hardware Acc.:       no
   * C89:                        no
   * Inline Code:                yes
   * Linux AF_ALG:               no
   * Linux KCAPI:                no
   * Linux devcrypto:            no
   * PK callbacks:               no
   * Crypto callbacks:           no
   * i.MX CAAM:                  no
   * IoT-Safe:                   no
   * IoT-Safe HWRNG:             no
   * NXP SE050:                  no
   * Maxim Integrated MAXQ10XX:  no
   * PSA:                        no
   * System CA certs:            yes
   * Dual alg cert support:      no
   * ERR Queues per Thread:      yes
   * rwlock:                     no
   * keylog export:              no
   * AutoSAR :                   no

---
./configure flags: '--enable-intelasm' '--enable-aesni' '--enable-sp' '--enable-sp-asm' '--enable-sp-math'
---
Note: Make sure your application includes "wolfssl/options.h" before any other wolfSSL headers.
      You can define "WOLFSSL_USE_OPTIONS_H" in your application to include this automatically.
config.status: creating stamp-h
config.status: creating Makefile
config.status: creating wolfssl/version.h
config.status: creating wolfssl/options.h
config.status: creating support/wolfssl.pc
config.status: creating debian/control
config.status: creating debian/changelog
config.status: creating rpm/spec
config.status: creating wolfcrypt/test/test_paths.h
config.status: creating scripts/unit.test
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands
config.status: executing wolfssl/wolfcrypt/async.h commands
config.status: executing wolfssl/wolfcrypt/fips.h commands
config.status: executing wolfssl/wolfcrypt/port/cavium/cavium_nitrox.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist.h commands
config.status: executing wolfssl/wolfcrypt/port/intel/quickassist_mem.h commands
cd /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable && make
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make -j5  all-recursive
make[3]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[4]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[4]: warning: -j5 forced in submake: resetting jobserver mode.
  CPPAS    wolfcrypt/src/src_libwolfssl_la-sha256_asm.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-sp_x86_64_asm.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sp_x86_64.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-sha512_asm.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha3.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-sha3_asm.lo
  CC       wolfcrypt/src/src_libwolfssl_la-logging.lo
  CC       wolfcrypt/src/src_libwolfssl_la-wc_port.lo
  CC       wolfcrypt/src/src_libwolfssl_la-error.lo
  CC       wolfcrypt/src/src_libwolfssl_la-wc_encrypt.lo
  CC       wolfcrypt/src/src_libwolfssl_la-signature.lo
  CC       wolfcrypt/src/src_libwolfssl_la-wolfmath.lo
  CC       wolfcrypt/src/src_libwolfssl_la-memory.lo
  CC       wolfcrypt/src/src_libwolfssl_la-dh.lo
  CC       wolfcrypt/src/src_libwolfssl_la-asn.lo
  CC       wolfcrypt/src/src_libwolfssl_la-coding.lo
  CC       wolfcrypt/src/src_libwolfssl_la-poly1305.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-poly1305_asm.lo
  CC       wolfcrypt/src/src_libwolfssl_la-md5.lo
  CC       wolfcrypt/src/src_libwolfssl_la-pwdbased.lo
  CC       wolfcrypt/src/src_libwolfssl_la-pkcs12.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-aes_asm.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-aes_gcm_asm.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-aes_xts_asm.lo
  CC       wolfcrypt/src/src_libwolfssl_la-chacha.lo
  CPPAS    wolfcrypt/src/src_libwolfssl_la-chacha_asm.lo
  CC       wolfcrypt/src/src_libwolfssl_la-chacha20_poly1305.lo
  CC       wolfcrypt/src/src_libwolfssl_la-ecc.lo
  CC       src/libwolfssl_la-internal.lo
  CC       src/libwolfssl_la-wolfio.lo
  CC       src/libwolfssl_la-keys.lo
  CC       src/libwolfssl_la-ssl.lo
  CC       src/libwolfssl_la-tls.lo
  CC       src/libwolfssl_la-tls13.lo
  CC       wolfcrypt/test/test.o
  CC       examples/benchmark/tls_bench.o
  CC       examples/client/client-client.o
  CC       examples/echoclient/echoclient.o
  CC       examples/echoserver/echoserver.o
  CC       examples/server/server-server.o
  CC       examples/asn1/asn1.o
  CC       examples/pem/pem.o
  CC       wolfcrypt/test/testsuite_testsuite_test-test.o
  CC       examples/client/testsuite_testsuite_test-client.o
  CC       examples/echoclient/testsuite_testsuite_test-echoclient.o
  CC       examples/echoserver/testsuite_testsuite_test-echoserver.o
  CC       examples/server/testsuite_testsuite_test-server.o
  CC       testsuite/testsuite_test-testsuite.o
  CC       tests/unit_test-unit.o
  CC       tests/unit_test-api.o
  CC       tests/unit_test-suites.o
  CC       tests/unit_test-hash.o
  CC       tests/unit_test-w64wrapper.o
  CC       tests/unit_test-srp.o
  CC       tests/unit_test-quic.o
  CC       examples/client/tests_unit_test-client.o
  CC       examples/server/tests_unit_test-server.o
  CC       wolfcrypt/benchmark/benchmark.o
  CC       wolfcrypt/src/src_libwolfssl_la-hmac.lo
  CC       wolfcrypt/src/src_libwolfssl_la-hash.lo
  CC       wolfcrypt/src/src_libwolfssl_la-cpuid.lo
  CC       wolfcrypt/src/src_libwolfssl_la-kdf.lo
  CC       wolfcrypt/src/src_libwolfssl_la-random.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha256.lo
  CC       wolfcrypt/src/src_libwolfssl_la-rsa.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sp_int.lo
  CC       wolfcrypt/src/src_libwolfssl_la-aes.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha.lo
  CC       wolfcrypt/src/src_libwolfssl_la-sha512.lo
  CCLD     src/libwolfssl.la
  CCLD     wolfcrypt/benchmark/benchmark
  CCLD     examples/benchmark/tls_bench
  CCLD     wolfcrypt/test/testwolfcrypt
  CCLD     examples/client/client
  CCLD     examples/echoclient/echoclient
  CCLD     examples/echoserver/echoserver
  CCLD     examples/server/server
  CCLD     examples/asn1/asn1
  CCLD     examples/pem/pem
  CCLD     testsuite/testsuite.test
  CCLD     tests/unit.test
make[4]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[3]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable'
test -f /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark || make benchmark-build
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark -rsa_sign -ecc
------------------------------------------------------------------------------
 wolfSSL version 5.7.6
------------------------------------------------------------------------------
Math:   Multi-Precision: Disabled
        Single Precision: ecc 256 384 521 rsa/dh 2048 3072 4096 asm sp_x86_64.c
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
ECDHE [      SECP256R1]   256    agree     17700 ops took 1.002 sec, avg 0.057 ms, 17660.740 ops/sec
ECDSA [      SECP256R1]   256     sign     44600 ops took 1.002 sec, avg 0.022 ms, 44511.736 ops/sec
ECDSA [      SECP256R1]   256   verify     16600 ops took 1.003 sec, avg 0.060 ms, 16547.072 ops/sec
Benchmark complete
make[1]: Leaving directory '/wolfcrypt_sgx_docker'
test -d /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable || make setup
cd /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX && ./clean.sh && \
git diff . | cat -n && \
sed -i 's|Wolfssl_C_Extra_Flags :=.*|Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX|' sgx_t_static.mk && \
make -f sgx_t_static.mk HAVE_WOLFSSL_BENCHMARK=1 HAVE_WOLFSSL_TEST=1 HAVE_WOLFSSL_SP=1 && \
ls -lah && test -f libwolfssl.sgx.static.lib.a
make[1]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
make[1]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
make[1]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.c:35:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.c:41:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.c:40:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.c:60:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.c:36:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.c:34:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.c:39:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.c:39:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.c:29:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.c:35:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.c:26:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.c:31:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.c:29:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/types.h:34,
                 from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.c:34:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.c:29:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.c:43:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.c:31:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.c:34:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.c:32:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.c:33:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.c:45:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.c:33:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.c:26:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/test.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/test.c
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark.c
ar rcs libwolfssl.sgx.static.lib.a /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/test.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark.o
LINK =>  libwolfssl.sgx.static.lib.a
make[1]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
total 1.1M
drwxr-xr-x.  2 root root  131 Feb  3 20:26 .
drwxr-xr-x. 59 root root  16K Feb  3 20:24 ..
-rw-r--r--.  1 root root 2.5K Feb  3 20:24 README.md
-rwxr-xr-x.  1 root root  185 Feb  3 20:24 build.sh
-rwxr-xr-x.  1 root root   41 Feb  3 20:24 clean.sh
-rw-r--r--.  1 root root  258 Feb  3 20:24 include.am
-rw-r--r--.  1 root root 989K Feb  3 20:26 libwolfssl.sgx.static.lib.a
-rw-r--r--.  1 root root 5.2K Feb  3 20:25 sgx_t_static.mk
cd __wolfssl_examples/SGX_Linux && \
sed -i 's|Wolfssl_C_Extra_Flags :=.*|Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX|' sgx_u.mk && sed -i 's|Wolfssl_C_Extra_Flags :=.*|Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX|' sgx_t.mk && \
sed -i 's/sgx_tstdcxx/sgx_tstdc/' sgx_t.mk && \
git diff . | cat -n && \
rm -f ./App && make clean all SGX_MODE=SIM SGX_PRERELEASE=0 SGX_DEBUG=0 \
        SGX_WOLFSSL_LIB=/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX WOLFSSL_ROOT=/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable \
        HAVE_WOLFSSL_TEST=' 1' HAVE_WOLFSSL_BENCHMARK=' 1' && \
ls -lah && ./App
     1  diff --git a/SGX_Linux/sgx_t.mk b/SGX_Linux/sgx_t.mk
     2  index 7153aa3..bd32625 100644
     3  --- a/SGX_Linux/sgx_t.mk
     4  +++ b/SGX_Linux/sgx_t.mk
     5  @@ -73,7 +73,7 @@ Wolfssl_Enclave_C_Flags := $(Flags_Just_For_C) $(Common_C_Cpp_Flags) $(Wolfssl_C
     6   Wolfssl_Enclave_Link_Flags := $(SGX_COMMON_CFLAGS) -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L$(SGX_LIBRARY_PATH) \
     7          -L$(SGX_WOLFSSL_LIB) -lwolfssl.sgx.static.lib \
     8          -Wl,--whole-archive -l$(Trts_Library_Name) -Wl,--no-whole-archive \
     9  -       -Wl,--start-group -lsgx_tstdc -lsgx_tstdcxx -l$(Crypto_Library_Name) -l$(Service_Library_Name) -Wl,--end-group \
    10  +       -Wl,--start-group -lsgx_tstdc -lsgx_tstdc -l$(Crypto_Library_Name) -l$(Service_Library_Name) -Wl,--end-group \
    11          -Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined \
    12          -Wl,-pie,-eenclave_entry -Wl,--export-dynamic  \
    13          -Wl,--defsym,__ImageBase=0 \
make[1]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_u.mk clean
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_t.mk clean
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_u.mk all
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
GEN  =>  untrusted/Wolfssl_Enclave_u.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DHAVE_WOLFSSL_TEST -DHAVE_WOLFSSL_BENCHMARK -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/Wolfssl_Enclave_u.c -o untrusted/Wolfssl_Enclave_u.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/Wolfssl_Enclave_u.c:1:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC   <=  untrusted/Wolfssl_Enclave_u.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DHAVE_WOLFSSL_TEST -DHAVE_WOLFSSL_BENCHMARK -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/App.c -o untrusted/App.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/App.h:29,
                 from untrusted/App.c:24:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  untrusted/App.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DHAVE_WOLFSSL_TEST -DHAVE_WOLFSSL_BENCHMARK -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/client-tls.c -o untrusted/client-tls.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/client-tls.h:26,
                 from untrusted/client-tls.c:22:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  untrusted/client-tls.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DHAVE_WOLFSSL_TEST -DHAVE_WOLFSSL_BENCHMARK -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/server-tls.c -o untrusted/server-tls.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/server-tls.h:26,
                 from untrusted/server-tls.c:22:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  untrusted/server-tls.c
LINK =>  App
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_t.mk all
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
GEN  =>  trusted/Wolfssl_Enclave_t.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from trusted/Wolfssl_Enclave_t.h:9,
                 from trusted/Wolfssl_Enclave_t.c:1:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC   <=  trusted/Wolfssl_Enclave_t.c
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -IInclude -Itrusted -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport-fno-builtin -fno-builtin-printf -I. -DWOLFSSL_SGX -DHAVE_WOLFSSL_TEST -DHAVE_WOLFSSL_BENCHMARK -c trusted/Wolfssl_Enclave.c -o trusted/Wolfssl_Enclave.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from trusted/Wolfssl_Enclave_t.h:9,
                 from trusted/Wolfssl_Enclave.c:25:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  trusted/Wolfssl_Enclave.c
-m64 -O2 -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L/opt/intel/sgxsdk/lib64 -L/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX -lwolfssl.sgx.static.lib -Wl,--whole-archive -lsgx_trts_sim -Wl,--no-whole-archive -Wl,--start-group -lsgx_tstdc -lsgx_tstdc -lsgx_tcrypto -lsgx_tservice_sim -Wl,--end-group -Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined -Wl,-pie,-eenclave_entry -Wl,--export-dynamic -Wl,--defsym,__ImageBase=0 -Wl,--version-script=trusted/Wolfssl_Enclave.lds@
LINK =>  Wolfssl_Enclave.so
<EnclaveConfiguration>
    <ProdID>0</ProdID>
    <ISVSVN>0</ISVSVN>
    <StackMaxSize>0x400000</StackMaxSize>
    <HeapMaxSize>0x1000000</HeapMaxSize>
    <TCSNum>10</TCSNum>
    <TCSPolicy>1</TCSPolicy>
    <DisableDebug>0</DisableDebug>
</EnclaveConfiguration>
tcs_num 10, tcs_max_num 10, tcs_min_pool 1
INFO: Enclave configuration 'MiscSelect' and 'MiscSelectMask' will prevent enclave from using dynamic features. To use the dynamic features on SGX2 platform, suggest to set MiscMask[0]=0 and MiscSelect[0]=1.
The required memory is 59691008B.
The required memory is 0x38ed000, 58292 KB.
handle_compatible_metadata: Overwrite with metadata version 0x100000004
Succeed.
SIGN =>  Wolfssl_Enclave.signed.so
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make[1]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
total 2.0M
drwxr-xr-x.  5 root root  16K Feb  3 20:26 .
drwxr-xr-x. 53 root root  16K Feb  3 20:24 ..
-rwxr-xr-x.  1 root root  37K Feb  3 20:26 App
-rw-r--r--.  1 root root  306 Feb  3 20:24 Makefile
drwxr-xr-x.  2 root root  191 Feb  3 20:24 README-images
-rw-r--r--.  1 root root 5.8K Feb  3 20:24 README.md
-rw-r--r--.  1 root root 922K Feb  3 20:26 Wolfssl_Enclave.signed.so
-rwxr-xr-x.  1 root root 922K Feb  3 20:26 Wolfssl_Enclave.so
-rwxr-xr-x.  1 root root  281 Feb  3 20:24 build.sh
-rw-r--r--.  1 root root 4.7K Feb  3 20:26 sgx_t.mk
-rw-r--r--.  1 root root 4.1K Feb  3 20:26 sgx_u.mk
drwxr-xr-x.  2 root root  16K Feb  3 20:26 trusted
drwxr-xr-x.  2 root root  16K Feb  3 20:26 untrusted
Usage:
        -c Run a TLS client in enclave
        -s Run a TLS server in enclave
        -t Run wolfCrypt tests only
        -b Run wolfCrypt benchmarks in enclave
cd __wolfssl_examples/SGX_Linux && ./App -b

Benchmark Test:
wolfCrypt Benchmark (block bytes 1048576, min 1.0 sec each)
RNG                         85 MiB took 1.037 seconds,   81.993 MiB/s
AES-128-CBC-enc            255 MiB took 1.018 seconds,  250.375 MiB/s
AES-128-CBC-dec            290 MiB took 1.015 seconds,  285.847 MiB/s
AES-192-CBC-enc            215 MiB took 1.021 seconds,  210.493 MiB/s
AES-192-CBC-dec            240 MiB took 1.010 seconds,  237.591 MiB/s
AES-256-CBC-enc            190 MiB took 1.026 seconds,  185.100 MiB/s
AES-256-CBC-dec            205 MiB took 1.003 seconds,  204.360 MiB/s
AES-128-GCM-enc             60 MiB took 1.044 seconds,   57.466 MiB/s
AES-128-GCM-dec             60 MiB took 1.048 seconds,   57.267 MiB/s
AES-192-GCM-enc             60 MiB took 1.077 seconds,   55.731 MiB/s
AES-192-GCM-dec             55 MiB took 1.091 seconds,   50.390 MiB/s
AES-256-GCM-enc             35 MiB took 1.089 seconds,   32.149 MiB/s
AES-256-GCM-dec             35 MiB took 1.039 seconds,   33.696 MiB/s
AES-128-GCM-enc-no_AAD      50 MiB took 1.003 seconds,   49.833 MiB/s
AES-128-GCM-dec-no_AAD      55 MiB took 1.076 seconds,   51.093 MiB/s
AES-192-GCM-enc-no_AAD      55 MiB took 1.059 seconds,   51.938 MiB/s
AES-192-GCM-dec-no_AAD      55 MiB took 1.004 seconds,   54.775 MiB/s
AES-256-GCM-enc-no_AAD      55 MiB took 1.027 seconds,   53.529 MiB/s
AES-256-GCM-dec-no_AAD      55 MiB took 1.038 seconds,   52.977 MiB/s
GMAC Default                70 MiB took 1.007 seconds,   69.515 MiB/s
3DES                        30 MiB took 1.089 seconds,   27.545 MiB/s
MD5                        570 MiB took 1.002 seconds,  568.620 MiB/s
SHA                        440 MiB took 1.015 seconds,  433.634 MiB/s
SHA-256                    145 MiB took 1.012 seconds,  143.223 MiB/s
HMAC-MD5                   570 MiB took 1.003 seconds,  568.084 MiB/s
HMAC-SHA                   430 MiB took 1.008 seconds,  426.537 MiB/s
HMAC-SHA256                135 MiB took 1.008 seconds,  133.989 MiB/s
PBKDF2                      21 KiB took 1.001 seconds,   20.605 KiB/s
RSA     2048   public      6300 ops took 1.009 sec, avg 0.160 ms, 6245.254 ops/sec
RSA     2048  private       200 ops took 1.674 sec, avg 8.370 ms, 119.477 ops/sec
DH      2048  key gen       283 ops took 1.001 sec, avg 3.537 ms, 282.758 ops/sec
DH      2048    agree       300 ops took 1.059 sec, avg 3.530 ms, 283.246 ops/sec
ECC   [      SECP256R1]   256  key gen      8600 ops took 1.011 sec, avg 0.118 ms, 8508.701 ops/sec
ECDHE [      SECP256R1]   256    agree      3300 ops took 1.027 sec, avg 0.311 ms, 3212.176 ops/sec
ECDSA [      SECP256R1]   256     sign      6100 ops took 1.011 sec, avg 0.166 ms, 6033.421 ops/sec
ECDSA [      SECP256R1]   256   verify      3100 ops took 1.014 sec, avg 0.327 ms, 3057.926 ops/sec
Benchmark complete
Benchmark Test: Return code 0
Wolfssl_C_Extra_Flags='-DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include' make benchmark-sgx
make[1]: Entering directory '/wolfcrypt_sgx_docker'
test -d /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable || make setup
cd /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX && ./clean.sh && \
git diff . | cat -n && \
sed -i 's|Wolfssl_C_Extra_Flags :=.*|Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include|' sgx_t_static.mk && \
make -f sgx_t_static.mk HAVE_WOLFSSL_BENCHMARK=1 HAVE_WOLFSSL_TEST=1 HAVE_WOLFSSL_SP=1 && \
ls -lah && test -f libwolfssl.sgx.static.lib.a
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.c:35:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.c:41:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.c:40:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.c:60:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.c:36:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.c:34:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.c:39:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.c:39:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.c:29:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.c:35:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.c:26:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.c:31:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.c:29:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/types.h:34,
                 from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.c:34:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.c:29:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.c:43:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.c:31:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.c:34:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.c:32:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.c:33:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.c:45:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.c:33:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.c:28:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.c:27:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.c:26:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/test.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/test.c
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DWOLFSSL_HAVE_SP_RSA -DWOLFSSL_HAVE_SP_DH -DWOLFSSL_HAVE_SP_ECC   -c -o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark.c
ar rcs libwolfssl.sgx.static.lib.a /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/aes.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/arc4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/asn.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/blake2b.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/camellia.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/coding.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/chacha20_poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/crl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/des3.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dh.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/tfm.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ecc.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/error.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hash.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/kdf.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/hmac.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/integer.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/internal.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/wolfio.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/keys.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/logging.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md4.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/md5.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/memory.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ocsp.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs7.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pkcs12.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/poly1305.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_port.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfmath.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/pwdbased.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/random.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/ripemd.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/rsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/dsa.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha256.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sha512.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/signature.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c32.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_c64.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/sp_int.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/ssl.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/src/tls.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wc_encrypt.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/src/wolfevent.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/test.o /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/benchmark.o
LINK =>  libwolfssl.sgx.static.lib.a
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX'
total 1.1M
drwxr-xr-x.  2 root root  131 Feb  3 20:27 .
drwxr-xr-x. 59 root root  16K Feb  3 20:24 ..
-rw-r--r--.  1 root root 2.5K Feb  3 20:24 README.md
-rwxr-xr-x.  1 root root  185 Feb  3 20:24 build.sh
-rwxr-xr-x.  1 root root   41 Feb  3 20:24 clean.sh
-rw-r--r--.  1 root root  258 Feb  3 20:24 include.am
-rw-r--r--.  1 root root 996K Feb  3 20:27 libwolfssl.sgx.static.lib.a
-rw-r--r--.  1 root root 5.2K Feb  3 20:26 sgx_t_static.mk
cd __wolfssl_examples/SGX_Linux && \
sed -i 's|Wolfssl_C_Extra_Flags :=.*|Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include|' sgx_u.mk && sed -i 's|Wolfssl_C_Extra_Flags :=.*|Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include|' sgx_t.mk && \
sed -i 's/sgx_tstdcxx/sgx_tstdc/' sgx_t.mk && \
git diff . | cat -n && \
rm -f ./App && make clean all SGX_MODE=SIM SGX_PRERELEASE=0 SGX_DEBUG=0 \
        SGX_WOLFSSL_LIB=/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX WOLFSSL_ROOT=/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable \
        HAVE_WOLFSSL_TEST=' 1' HAVE_WOLFSSL_BENCHMARK=' 1' && \
ls -lah && ./App
     1  diff --git a/SGX_Linux/sgx_t.mk b/SGX_Linux/sgx_t.mk
     2  index 7153aa3..016aba1 100644
     3  --- a/SGX_Linux/sgx_t.mk
     4  +++ b/SGX_Linux/sgx_t.mk
     5  @@ -40,7 +40,7 @@ endif
     6   Crypto_Library_Name := sgx_tcrypto
     7
     8
     9  -Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX
    10  +Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include
    11   Wolfssl_Include_Paths := -I$(WOLFSSL_ROOT)/ \
    12                                                   -I$(WOLFSSL_ROOT)/wolfcrypt/
    13
    14  @@ -73,7 +73,7 @@ Wolfssl_Enclave_C_Flags := $(Flags_Just_For_C) $(Common_C_Cpp_Flags) $(Wolfssl_C
    15   Wolfssl_Enclave_Link_Flags := $(SGX_COMMON_CFLAGS) -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L$(SGX_LIBRARY_PATH) \
    16          -L$(SGX_WOLFSSL_LIB) -lwolfssl.sgx.static.lib \
    17          -Wl,--whole-archive -l$(Trts_Library_Name) -Wl,--no-whole-archive \
    18  -       -Wl,--start-group -lsgx_tstdc -lsgx_tstdcxx -l$(Crypto_Library_Name) -l$(Service_Library_Name) -Wl,--end-group \
    19  +       -Wl,--start-group -lsgx_tstdc -lsgx_tstdc -l$(Crypto_Library_Name) -l$(Service_Library_Name) -Wl,--end-group \
    20          -Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined \
    21          -Wl,-pie,-eenclave_entry -Wl,--export-dynamic  \
    22          -Wl,--defsym,__ImageBase=0 \
    23  diff --git a/SGX_Linux/sgx_u.mk b/SGX_Linux/sgx_u.mk
    24  index b5792f1..cb0cdc8 100644
    25  --- a/SGX_Linux/sgx_u.mk
    26  +++ b/SGX_Linux/sgx_u.mk
    27  @@ -38,7 +38,7 @@ else
    28          Urts_Library_Name := sgx_urts
    29   endif
    30
    31  -Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX
    32  +Wolfssl_C_Extra_Flags := -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include
    33   Wolfssl_Include_Paths := -I$(WOLFSSL_ROOT)/ \
    34                                                   -I$(WOLFSSL_ROOT)/wolfcrypt/
    35
make[2]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_u.mk clean
make[3]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make[3]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_t.mk clean
make[3]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make[3]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_u.mk all
make[3]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
GEN  =>  untrusted/Wolfssl_Enclave_u.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/Wolfssl_Enclave_u.c -o untrusted/Wolfssl_Enclave_u.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/Wolfssl_Enclave_u.c:1:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC   <=  untrusted/Wolfssl_Enclave_u.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/App.c -o untrusted/App.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/App.h:29,
                 from untrusted/App.c:24:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  untrusted/App.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/client-tls.c -o untrusted/client-tls.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/client-tls.h:26,
                 from untrusted/client-tls.c:22:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  untrusted/client-tls.c
cc -m64 -O2 -fPIC -Wno-attributes -IInclude -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/test/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/benchmark/ -Iuntrusted -I/opt/intel/sgxsdk/include -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -DNDEBUG -UEDEBUG -UDEBUG -c untrusted/server-tls.c -o untrusted/server-tls.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from untrusted/Wolfssl_Enclave_u.h:10,
                 from untrusted/server-tls.h:26,
                 from untrusted/server-tls.c:22:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  untrusted/server-tls.c
LINK =>  App
make[3]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make -ef sgx_t.mk all
make[3]: Entering directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
GEN  =>  trusted/Wolfssl_Enclave_t.c
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from trusted/Wolfssl_Enclave_t.h:9,
                 from trusted/Wolfssl_Enclave_t.c:1:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC   <=  trusted/Wolfssl_Enclave_t.c
cc -Wno-implicit-function-declaration -std=c99 -m64 -O2 -nostdinc -fvisibility=hidden -fpie -fstack-protector -IInclude -Itrusted -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/ -I/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfcrypt/ -I/opt/intel/sgxsdk/include -I/opt/intel/sgxsdk/include/tlibc -I/opt/intel/sgxsdk/include/stlport-fno-builtin -fno-builtin-printf -I. -DWOLFSSL_SGX -DUSE_INTEL_SPEEDUP -DWOLFSSL_AESNI -maes -I/usr/lib/gcc/x86_64-redhat-linux/8/include -c trusted/Wolfssl_Enclave.c -o trusted/Wolfssl_Enclave.o
In file included from /wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/ssl.h:33,
                 from trusted/Wolfssl_Enclave_t.h:9,
                 from trusted/Wolfssl_Enclave.c:25:
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/wolfssl/wolfcrypt/settings.h:349:6: warning: #warning "No configuration for wolfSSL detected, check header order" [-Wcpp]
     #warning "No configuration for wolfSSL detected, check header order"
      ^~~~~~~
CC  <=  trusted/Wolfssl_Enclave.c
-m64 -O2 -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L/opt/intel/sgxsdk/lib64 -L/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX -lwolfssl.sgx.static.lib -Wl,--whole-archive -lsgx_trts_sim -Wl,--no-whole-archive -Wl,--start-group -lsgx_tstdc -lsgx_tstdc -lsgx_tcrypto -lsgx_tservice_sim -Wl,--end-group -Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined -Wl,-pie,-eenclave_entry -Wl,--export-dynamic -Wl,--defsym,__ImageBase=0 -Wl,--version-script=trusted/Wolfssl_Enclave.lds@
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX/libwolfssl.sgx.static.lib.a(aes.o): In function `AES_set_encrypt_key_AESNI':
aes.c:(.text+0xcc): undefined reference to `AES_128_Key_Expansion_AESNI'
aes.c:(.text+0xe4): undefined reference to `AES_256_Key_Expansion_AESNI'
aes.c:(.text+0x104): undefined reference to `AES_192_Key_Expansion_AESNI'
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX/libwolfssl.sgx.static.lib.a(aes.o): In function `wc_AesEncrypt':
aes.c:(.text+0x33d): undefined reference to `AES_ECB_encrypt_AESNI'
aes.c:(.text+0x377): undefined reference to `AES_ECB_encrypt_AESNI'
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX/libwolfssl.sgx.static.lib.a(aes.o): In function `wc_AesSetKeyLocal.constprop.4':
aes.c:(.text+0x1789): undefined reference to `cpuid_get_flags'
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX/libwolfssl.sgx.static.lib.a(aes.o): In function `wc_AesCbcEncrypt':
aes.c:(.text+0x1d60): undefined reference to `AES_CBC_encrypt_AESNI'
aes.c:(.text+0x1de3): undefined reference to `AES_CBC_encrypt_AESNI'
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX/libwolfssl.sgx.static.lib.a(aes.o): In function `wc_AesCbcDecrypt':
aes.c:(.text+0x1f28): undefined reference to `AES_ECB_decrypt_AESNI'
aes.c:(.text+0x2df5): undefined reference to `AES_CBC_decrypt_AESNI_by8'
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX/libwolfssl.sgx.static.lib.a(aes.o): In function `wc_AesGcmEncrypt':
aes.c:(.text+0x376d): undefined reference to `AES_GCM_encrypt_avx1'
aes.c:(.text+0x379f): undefined reference to `AES_GCM_encrypt_avx2'
aes.c:(.text+0x37f7): undefined reference to `AES_GCM_encrypt_aesni'
/wolfcrypt_sgx_docker/__wolfssl_v5.7.6-stable/IDE/LINUX-SGX/libwolfssl.sgx.static.lib.a(aes.o): In function `wc_AesGcmDecrypt':
aes.c:(.text+0x3c8f): undefined reference to `AES_GCM_decrypt_avx1'
aes.c:(.text+0x3cf0): undefined reference to `AES_GCM_decrypt_avx2'
aes.c:(.text+0x3d53): undefined reference to `AES_GCM_decrypt_aesni'
collect2: error: ld returned 1 exit status
make[3]: *** [sgx_t.mk:134: Wolfssl_Enclave.so] Error 1
make[3]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make[2]: *** [Makefile:14: all] Error 2
make[2]: Leaving directory '/wolfcrypt_sgx_docker/__wolfssl_examples/SGX_Linux'
make[1]: *** [Makefile:61: sgx-example-build] Error 2
make[1]: Leaving directory '/wolfcrypt_sgx_docker'
make: *** [Makefile:25: benchmark-sgx-intel] Error 2
make[1]: *** [Makefile:8: docker-shell] Error 2
make[1]: Leaving directory '/home/ec2-user/wolfssl_wolfcrypt/wolfcrypt_sgx_docker'

```