#!/bin/sh

# Serve backend on port 8002 (actually 8082) (see https://github.com/dart-lang/dart-pad/blob/master/CONTRIBUTING.md)
#cd /app/dart-services && grind serve &

# Serve frontend on port 8000 (see above git)
cd /app/dart-pad && grind serve-custom-backend

