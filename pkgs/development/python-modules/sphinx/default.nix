{ lib
, buildPythonPackage
, fetchPypi
, pytest
, simplejson
, mock
, glibcLocales
, html5lib
, pythonOlder
, enum34
, python
, docutils
, jinja2
, pygments
, alabaster
, Babel
, snowballstemmer
, six
, sqlalchemy
, whoosh
, imagesize
, requests
, sphinxcontrib-websupport
, typing
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Sphinx";
  version = "1.6.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "af8bdb8c714552b77d01d4536e3d6d2879d6cb9d25423d29163d5788e27046e6";
  };
  LC_ALL = "en_US.UTF-8";

  checkInputs = [ pytest ];
  buildInputs = [ simplejson mock glibcLocales html5lib ] ++ lib.optional (pythonOlder "3.4") enum34;
  # Disable two tests that require network access.
  checkPhase = ''
    cd tests; ${python.interpreter} run.py --ignore py35 -k 'not test_defaults and not test_anchors_ignored'
  '';
  propagatedBuildInputs = [
    docutils
    jinja2
    pygments
    alabaster
    Babel
    snowballstemmer
    six
    sqlalchemy
    whoosh
    imagesize
    requests
    sphinxcontrib-websupport
  ] ++ lib.optional (pythonOlder "3.5") typing;

  # Lots of tests. Needs network as well at some point.
  doCheck = false;

  # https://github.com/NixOS/nixpkgs/issues/22501
  # Do not run `python sphinx-build arguments` but `sphinx-build arguments`.
  postPatch = ''
    substituteInPlace sphinx/make_mode.py --replace "sys.executable, " ""
  '';

  meta = {
    description = "A tool that makes it easy to create intelligent and beautiful documentation for Python projects";
    homepage = http://sphinx.pocoo.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nand0p ];
  };
}