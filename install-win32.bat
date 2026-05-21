if exist bin rmdir /s /q bin
em build
copy /Y bin\emeralds.exe bin\em.exe
copy /Y bin\em.exe C:\msys64\ucrt64\bin\
copy /Y bin\emeralds.exe C:\msys64\ucrt64\bin\
