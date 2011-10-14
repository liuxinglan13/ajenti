PYTHON=`which python`
DESTDIR=/
BUILDIR=$(CURDIR)/debian/ajenti
PROJECT=ajenti
VERSION=0.5.101


SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
DOCBUILDDIR   = docs/build
DOCSOURCEDIR   = docs/source
ALLSPHINXOPTS   = -d $(DOCBUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) $(DOCSOURCEDIR)

doc:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(DOCBUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

cdoc:
	rm -rf $(DOCBUILDDIR)/*
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(DOCBUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

install:
	$(PYTHON) setup.py install --root $(DESTDIR) $(COMPILE)

rpm:
	rm -rf dist/*.rpm
	$(PYTHON) setup.py sdist 
	#$(PYTHON) setup.py bdist_rpm --spec-file dist/ajenti.spec #--post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall
	rpmbuild -bb dist/ajenti.spec
	mv ~/rpmbuild/RPMS/noarch/$(PROJECT)*.rpm dist

deb:
	rm -rf dist/*.deb
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../
	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	dpkg-buildpackage -b -rfakeroot -us -uc
	rm ../$(PROJECT)*.orig.tar.gz
	rm ../$(PROJECT)*.changes
	mv ../$(PROJECT)*.deb dist/

tgz:
	rm -rf dist/*.tar.gz
	$(PYTHON) setup.py sdist 
	tar xvf dist/*.tar.gz -C dist
	rm dist/*.tar.gz
	mv dist/ajenti-$(VERSION) dist/pkg-tmp
	tar czf dist/ajenti-$(VERSION).tar.gz  -C dist/pkg-tmp `ls dist/pkg-tmp`
	rm -r dist/pkg-tmp
	
clean:
	$(PYTHON) setup.py clean
	rm -rf $(DOCBUILDDIR)/*
	$(MAKE) -f $(CURDIR)/debian/rules clean
	rm -rf build/ MANIFEST ajenti.egg-info
	find . -name '*.pyc' -delete
