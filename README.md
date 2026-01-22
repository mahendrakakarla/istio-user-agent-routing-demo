######################

Design and explain an end‑to‑end solution where Terraform provisions an AWS EKS cluster, you deploy one Java microservice that has two versions (v-android and v-ios) as separate container deployments, and you configure Istio so that calls to the same HTTP endpoint are routed to the correct version based on the HTTP User-Agent (Android vs iOS).

For this demo, I am using minikube to setup cluster and deploy.
Repo Structure

istio-user-agent-routing-demo/
├── README.md
├── manifests/
│   ├── app.yaml
│   └── istio-routing.yaml
├── scripts/
│   ├── start-minikube.sh
│   ├── install-istio.sh
│   └── port-forward.sh
├── test/
│   └── test-ua-routing.sh
└── .gitignore

################# IMPORTANT ######################

git clone https://github.com/mahendrakakarla/istio-user-agent-routing-demo.git
cd istio-user-agent-routing-demo

./scripts/start-minikube.sh
./scripts/install-istio.sh

kubectl apply -f manifests/app.yaml
kubectl apply -f manifests/istio-routing.yaml

./scripts/port-forward.sh

On New terminal: 
To test urls - use curl command as showing in step-7 below
By using script use - 
		./validation/validate-ua-routing.sh

########################################################

--------------------------------Manual Steps----------------------------------

#Manual steps for istio user-agent routing application demo setup

1. Minikube install on Mac
2. Istio installed correctly
3. Sidecar injection working
4. Two service versions
5. User-Agent based routing
6. Same endpoint behavior
7. Test

STEP 1: 
1.1 Install Minikube binary
curl -LO https://github.com/kubernetes/minikube/releases/download/v1.37.0/minikube-darwin-arm64
chmod +x minikube-darwin-arm64
sudo mv minikube-darwin-arm64 /usr/local/bin/minikube
1.2 minikube version
1.3 minikube start --driver=docker --cpus=2 --memory=2048
1.4 Verify Minikube Health
	kubectl get nodes
	minikube status

STEP 2: Install Istio
2.1 Verify istioctl
	istioctl version
2.2 Install Istio
	istioctl install --set profile=demo -y

STEP 3: Create App Namespace + Enable Sidecar Injection
kubectl create namespace app-dev
kubectl label namespace app-dev istio-injection=enabled --overwrite
	kubectl get namespace app-dev --show-labels

STEP 4: Deploy Android + iOS App Versions
4.1 Create app manifest

Create file app.yaml and apply kubectl apply -f app.yaml
	Verify: kubectl get pods -n app-dev

STEP 5: Configure Istio Routing (User-Agent Based)
5.1 Create Istio routing manifest

Create file istio-routing.yaml and apply kubectl apply -f istio-routing.yaml
	Verify: kubectl get gateway,virtualservice,destinationrule -n app-dev


STEP 6: Expose Istio Ingress Locally
Port-forward the Istio ingress gateway: kubectl -n istio-system port-forward svc/istio-ingressgateway 8080:80

STEP 7: TEST
Open a new terminal.

Android request validation: curl -H "User-Agent: Mozilla/5.0 (Linux; Android 14)" http://localhost:8080/app 
output: Hello from ANDROID version

iOS request validation: curl -H "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)" http://localhost:8080/app
output: Hello from IOS version

No User-Agent (fallback) validation: curl http://localhost:8080/app
output: Hello from ANDROID version


