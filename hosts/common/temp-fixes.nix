#nixpkgs issue: 493679

(final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      picosvg = python-prev.picosvg.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];
})
