## push to gcloud container registry

requisites:
install gcloud SDK
install docker with user permissions 

config docker:

gcloud auth configure-docker

tag an image:

docker tag gcr.io/google-samples/hello-app:1.0 gcr.io/PROJECT_ID/quickstart-image:tag1

push image:

docker push gcr.io/PROJECT_ID/quickstart-image:tag1

pull image:

docker pull gcr.io/PROJECT_ID/quickstart-image:tag1


delete image:

gcloud container images delete gcr.io/PROJECT_ID/quickstart-image:tag1 --force-delete-tags

