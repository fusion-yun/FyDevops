help([==[
Description
===========
MATLAB is a high-level language and interactive environment
 that enables you to perform computationally intensive tasks faster than with
 traditional programming languages such as C, C++, and Fortran."

More information
================
 - Homepage: http://www.mathworks.com/products/matlab
]==])
whatis([==[Description: MATLAB is a high-level language and interactive environment
 that enables you to perform computationally intensive tasks faster than with
 traditional programming languages such as C, C++, and Fortran.]==])
whatis([==[Homepage: http://www.mathworks.com/products/matlab]==])
whatis([==[URL: http://www.mathworks.com/products/matlab]==])
local root = "/packages/software/MATLAB/${MATLAB_VERSION}"
conflict("MATLAB")
if not ( isloaded("Java/13.0.1") ) then
    load("Java/${JAVA_VERSION}")
end
if not ( isloaded("GCC/6.3.0") ) then
    load("GCCcore/${GCC_VERSION}")
end
prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOTMATLAB", root)
setenv("EBVERSIONMATLAB", "${MATLAB_VERSION}")
setenv("EBDEVELMATLAB", pathJoin(root, "easybuild/MATLAB-R2019b-easybuild-devel"))
prepend_path("PATH", root)
setenv("_JAVA_OPTIONS", "-Xmx256m")
setenv("LM_LICENSE_FILE", "202.127.204.4:25030") 
