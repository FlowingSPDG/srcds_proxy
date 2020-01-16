package proxy

import (
	"github.com/FlowingSPDG/srcds_proxy/proxy/filter"
	"github.com/FlowingSPDG/srcds_proxy/proxy/mapper"
	"github.com/FlowingSPDG/srcds_proxy/proxy/models"
	"github.com/golang/glog"
)

// Launch launches the proxy.
func Launch(ListenAddr string, ServerAddr string) error {

	glog.Info("Starting proxy.")
	glog.Info("Listen address: ", ListenAddr)
	glog.Info("Proxy to address: ", ServerAddr)

	listenHost, err := mapper.StringToHost(ListenAddr)
	if err != nil {
		glog.Fatal(err)
	}

	dstHost, err := mapper.StringToHost(ServerAddr)
	if err != nil {
		glog.Fatal(err)
	}

	rootQueue, clientConn := createQueueFromConn(listenHost)
	ctx := models.ProxyContext{
		ClientToServerTbl: &models.NatTable{},
		ServerToClientTbl: map[models.Host]*models.Host{},
		ServerHost:        dstHost,
		ProxyHost:         listenHost,
		RootQueue:         rootQueue,
	}

	queue := (<-chan models.Packet)(ctx.RootQueue)
	queue = filter.TranslateClientPackets(ctx, queue)
	queue = filter.TranslateServerPackets(ctx, queue, clientConn)
	filter.SendQueue(queue, clientConn)

	return nil

}
