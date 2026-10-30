
### ---  Application  --- ### 
resource "helm_release" "argo_events" {
  name             = "argo-events"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-events"
  namespace        = "argo-events"
  version          = "2.4.9"
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900

  depends_on = [
    helm_release.ingress_nginx
  ]
}

resource "helm_release" "oneuptime" {
  name             = "oneuptime"
  repository       = "https://helm-chart.oneuptime.com"
  chart            = "oneuptime"
  version          = "14.0.78"
  namespace        = "oneuptime"
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 1200

  values = [
    yamlencode({
      host         = "uptime.crypterio.co"
      httpProtocol = "https"

      global = {
        storageClass = "standard"
      }

      # Explicitly define Azure marketplace configuration as an object.
      azure = {
        tenantId     = null
        clientId     = null
        clientSecret = null
      }
    })
  ]

  depends_on = [helm_release.argo_events]
}
