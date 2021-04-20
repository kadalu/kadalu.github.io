#!/bin/bash

set -e

ROOT_DIR=$(ruby -e 'puts File.expand_path(".")')

function version_checkout
{
    local project_name=$1
    local version=$2
    cd "${ROOT_DIR}/tmprepos/${project_name}" && git checkout -b v${version} ${version}
}

function prepare_versioned_docs
{
    local projects_yaml_file=$1
    local project_name=$2
    local project_repo=$3
    local docs_dir=$4
    local version=$5

    mkdir -p "${ROOT_DIR}/content/docs/${project_name}"

    project_dir="${ROOT_DIR}/content/docs/${project_name}"
    version_dir="${project_dir}/${version}"

    # Copy the docs directory to respective version directory
    cp -r "${ROOT_DIR}/tmprepos/${project_name}/${docs_dir}" "${version_dir}"

    # Create empty versions.html file in project root dir
    echo > "${project_dir}/versions.html"

    # Create empty redirect.html file
    echo > "${version_dir}/redirect.html"

    # Replace Relative links, *.adoc links
    ruby ${ROOT_DIR}/scripts/process_files.rb "${version_dir}" ${project_name} ${project_repo} ${version}
}


function build_docs_site
{
    cd ${ROOT_DIR} && bundle install
    cd ${ROOT_DIR} && npm install
    cd ${ROOT_DIR} && npm run prod:css
    cd ${ROOT_DIR} && bundle exec nanoc compile --env prod
}

function main
{
    local projects_yaml_file=$(ruby -e "puts File.expand_path(\"$1\")")

    mkdir -p "${ROOT_DIR}/tmprepos"

    # Copy projects.yml to root dir
    cp "${projects_yaml_file}" "${ROOT_DIR}/content/docs/"

    ruby ${ROOT_DIR}/scripts/projects.rb $projects_yaml_file | while read project_line
    do
        local project_name=$(echo $project_line | awk -F# '{print $1}')
        local project_repo=$(echo $project_line | awk -F# '{print $2}')
        local docs_dir=$(echo $project_line | awk -F# '{print $3}')

        # Delete the Project Repo if exists
        rm -rf "${ROOT_DIR}/tmprepos/${project_name}"

        # Clear the directory before copying the doc directory from repo
        rm -rf "${ROOT_DIR}/content/docs/${project_name}"

        # Clone the Project Repo and fetch all tags
        git clone --depth 1 ${project_repo} ${ROOT_DIR}/tmprepos/${project_name}
        cd ${ROOT_DIR}/tmprepos/${project_name} && git fetch --depth=1 origin +refs/tags/*:refs/tags/*

        # For each required version checkout and prepare the docs
        ruby ${ROOT_DIR}/scripts/versions.rb $projects_yaml_file $project_name | while read version
        do
            version_checkout $project_name $version
            prepare_versioned_docs $projects_yaml_file $project_name $project_repo $docs_dir $version
        done

        # Checkout the Latest alias version again and setup as required
        latest_alias=$(ruby ${ROOT_DIR}/scripts/latest_alias.rb $projects_yaml_file $project_name)
        cd "${ROOT_DIR}/tmprepos/${project_name}" && git checkout v${latest_alias}
        prepare_versioned_docs $projects_yaml_file $project_name $project_repo $docs_dir "latest"
    done

    build_docs_site
}

echo "Project directory: ${ROOT_DIR}"
main $1
