#!/bin/bash

# cd ..

echo "Creating virtual env"
virtualenv --no-site-packages pyenv

echo "Activating virtual env"
source pyenv/bin/activate

echo "Installing requirements"
pip install -r requirements/dev.txt

# changing root directory
cd "src"

# before running collectstatic, make sure that
# `root_dir/static` exists

mkdir "bharathacks/static"
echo "Creating Static directory"
if [ ! -d "static" ]; then
    mkdir "static"
fi

if [ -f "bower.json" ]; then
    # before running bower install,
    # make sure bharathacks/static/bower_components exists

    if [ ! -d "bharathacks/static/bower_components" ]; then
        mkdir -p "bharathacks/static/bower_components"
    fi

    # create `.bowerrc` dynamically, so that template variable
    # project_name is substituted properly

cat <<'EOF' > ".bowerrc"
{
    "directory": "bharathacks/static/bower_components"
}
EOF
    echo "Running bower install"
    bower install
fi

echo "Collecting static files"
python manage.py collectstatic --noinput

echo "Running migrations"
python manage.py migrate --noinput
