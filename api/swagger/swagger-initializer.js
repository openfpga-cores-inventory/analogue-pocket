window.onload = function () {
  //<editor-fold desc="Changeable Configuration Block">

  // the following lines will be replaced by docker/configurator, when it runs in a docker-container
  window.ui = SwaggerUIBundle({
    urls: [
      { url: "https://openfpga-cores-inventory.github.io/analogue-pocket/api/v0/openapi.yaml", name: "v0" },
      { url: "https://openfpga-cores-inventory.github.io/analogue-pocket/api/v1/openapi.yaml", name: "v1" },
      { url: "https://openfpga-cores-inventory.github.io/analogue-pocket/api/v2/openapi.yaml", name: "v2" },
      { url: "https://openfpga-cores-inventory.github.io/analogue-pocket/api/v3/openapi.yaml", name: "v3" },
    ],
    "urls.primaryName": "v3",
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: "StandaloneLayout"
  });

  //</editor-fold>
};
