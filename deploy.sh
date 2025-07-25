# $SHA is the unique commit ID, to unique identify each version of docker
# so that kubernetes will be able to know there's a new image version, and update the image
docker build -t yingtingyu33/multi-client:latest -t yingtingyu33/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t yingtingyu33/multi-server:latest -t yingtingyu33/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t yingtingyu33/multi-worker:latest -t yingtingyu33/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# need to push twice since there are two tags
# docker would push the image to a specific version 
docker push yingtingyu33/multi-client:latest
docker push yingtingyu33/multi-server:latest
docker push yingtingyu33/multi-worker:latest

docker push yingtingyu33/multi-client:$SHA
docker push yingtingyu33/multi-server:$SHA
docker push yingtingyu33/multi-worker:$SHA


kubectl apply -f k8s

kubectl set image deployments/server-deployment server=yingtingyu33/multi-server:$SHA
kubectl set image deployments/client-deployment client=yingtingyu33/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=yingtingyu33/multi-worker:$SHA