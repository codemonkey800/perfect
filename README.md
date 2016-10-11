# Docker Image - Perfect

[![](https://images.microbadger.com/badges/version/codemonkey800/perfect.svg)](https://microbadger.com/images/codemonkey800/perfect "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/codemonkey800/perfect.svg)](https://microbadger.com/images/codemonkey800/perfect "Get your own image badge on microbadger.com")

A base Docker image for deploying [Swift](https://swift.org/) web applications using the [Perfect](http://www.perfect.org/) web framework. The image's base is [Ubuntu 15.10](https://hub.docker.com/_/ubuntu/), and has the latest snapshot built by Apple. The perfect library is built directly from source.

PerfectLib is installed in `/usr/local/lib` and the HTTP server and CGI executables are intalled in `/usr/local/bin`. The source is downloaded into `/usr/local/src`.

# Setting Up
Pull the container from Docker hub:
```bash
$ docker pull codemonkey800/perfect
```

Then write your `Dockerfile` sort of like this:
```
FROM codemonkey800/perfect

COPY . /opt/shitty-app
WORKDIR /opt/shitty-app
RUN make
EXPOSE 8080
ENTRYPOINT ["perfectserverhttp", "--port", "8080", "--root", "."]
```

The `Dockerfile` above requires your code to be built with `make`. Take a look at the Perfect [examples](https://github.com/PerfectlySoft/Perfect/tree/master/Examples), or use the example `Makefile` below.

# Example Makefile
```
SHELL = /bin/bash
OS = $(shell uname)
PERFECT_ROOT = /usr/local/src/Perfect/PerfectLib
MODULE_CACHE_PATH = /tmp/modulecache
SWIFTC = swift
SWIFTC_FLAGS = -frontend -c -module-cache-path $(MODULE_CACHE_PATH) -emit-module \
	           -I /usr/local/lib -I $(PERFECT_ROOT)/linked/LibEvent \
			   -I $(PERFECT_ROOT)/linked/OpenSSL_Linux -I $(PERFECT_ROOT)/linked/ICU \
			   -I $(PERFECT_ROOT)/linked/SQLite3 -I $(PERFECT_ROOT)/linked/LinuxBridge
Linux_SHLIB_PATH = $(shell dirname $(shell dirname $(shell which swiftc)))/lib/swift/linux
SHLIB_PATH = -L$($(OS)_SHLIB_PATH)
LFLAGS = $(SHLIB_PATH) -lFoundation -lswiftCore -lswiftGlibc /usr/local/lib/PerfectLib.so \
         -Xlinker -rpath -Xlinker $($(OS)_SHLIB_PATH) -shared
TARGETS = HelloWorld

all: $(TARGETS)

builddir:
	mkdir -p PerfectLibraries

$(TARGETS): builddir
	@echo $@
	$(SWIFTC) $(SWIFTC_FLAGS) '$@/$@.swift' \
		-o $@.o -module-name $@ -emit-module-path PerfectLibraries/$@.swiftmodule
	clang++ $(LFLAGS) $@.o -o PerfectLibraries/$@.so

clean:
	rm -rvf *.o PerfectLibraries SQLiteDBs
```

# License
The MIT License (MIT)

Copyright (c) 2016 Jeremy Asuncion

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
