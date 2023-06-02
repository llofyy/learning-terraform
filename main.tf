terraform {
    required_providers {
      docker = {
        source = "kreuzwerker/docker",
        version = "3.0.2"
      }
    }
}

provider "docker" {
    host = "tcp://localhost:2375"
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

resource "docker_container" "webserver" {
  image = docker_image.ubuntu.image_id
  name = "terraform-docker"
  must_run = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "terraform-ngnix" {
  image = docker_image.nginx.image_id
  name = "nginx-latest"
  ports {
    internal = 80
    external = 8000
  }
}



