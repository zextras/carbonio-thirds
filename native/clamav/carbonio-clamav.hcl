services {
  check {
    tcp = "127.0.0.1:3310"
    timeout = "1s"
    interval = "5s"
  }
  connect {
    sidecar_service {
    }
  }
  name = "carbonio-clamav"
  port = 3310
}
