services {
  check {
    tcp      = "127.0.0.1:11211"
    timeout  = "1s"
    interval = "5s"
  }
  connect {
    sidecar_service { }
  }
  name = "carbonio-memcached"
  port = 443
}
