package main

import (
	"flag"

	"github.com/FlowingSPDG/srcds_proxy/proxy"
	"github.com/golang/glog"
)

const (
	defaultListenIPPort = "0.0.0.0:27015"
	defaultServerIPPort = "192.168.0.2:27015"
)

func main() {
	var (
		listen = flag.String("listen", defaultListenIPPort, "Where proxy listens. e.g. 0.0.0.0:27015")
		server = flag.String("server", defaultServerIPPort, "Where packet delivered. e.g. 192.168.0.2:27015")
	)
	flag.Parse()
	if err := proxy.Launch(*listen, *server); err != nil {
		glog.Error("Failed to launch: ", err)
	}
}
