help([==[

Description
===========
MATLAB is a high-level language and interactive environment
 that enables you to perform computationally intensive tasks faster than with
 traditional programming languages such as C, C++, and Fortran.


More information
================
 - Homepage: http://www.mathworks.com/products/matlab
]==])

whatis([==[Description: MATLAB is a high-level language and interactive environment
 that enables you to perform computationally intensive tasks faster than with
 traditional programming languages such as C, C++, and Fortran.]==])
whatis([==[Homepage: http://www.mathworks.com/products/matlab]==])
whatis([==[URL: http://www.mathworks.com/products/matlab]==])

local root = "/packages/software/MATLAB/R2019b"

conflict("MATLAB")

if not ( isloaded("Java/13.0.1") ) then
    load("Java/13.0.1")
end

prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOTMATLAB", root)
setenv("EBVERSIONMATLAB", "R2019b")
setenv("EBDEVELMATLAB", pathJoin(root, "easybuild/MATLAB-R2019b-easybuild-devel"))

prepend_path("PATH", root)
setenv("_JAVA_OPTIONS", "-Xmx256m")
-- Built with EasyBuild version 4.0.1
