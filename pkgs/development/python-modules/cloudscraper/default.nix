{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
, requests-toolbelt
, pyparsing
}:

buildPythonPackage rec {
  pname = "cloudscraper";
  version = "1.2.69";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H/S+/urmOmcHbAJkUVFik1mB3V1RVS8FLcJmv2SZc0U=";
  };

  propagatedBuildInputs = [
    requests
    requests-toolbelt
    pyparsing
  ];

  # The tests require several other dependencies, some of which aren't in
  # nixpkgs yet, and also aren't included in the PyPI bundle.  TODO.
  doCheck = false;

  pythonImportsCheck = [
    "cloudscraper"
  ];

  meta = with lib; {
    description = "Python module to bypass Cloudflare's anti-bot page";
    homepage = "https://github.com/venomous/cloudscraper";
    changelog = "https://github.com/VeNoMouS/cloudscraper/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kini ];
  };
}
