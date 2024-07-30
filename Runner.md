
## Running The Pipeline
```shell
docker run -d -p 9099:9099 \
  --add-host=host.docker.internal:host-gateway \
  -v pipelines:/app/pipelines \
  -v /chroma_prod:/app/chroma_prod \
  -v /graphrag:/app/graphrag \
  --name pipelines \
  --restart always \
  -e OPENAI_API_KEY=sk-************ \
  buntha/transfusion-pipelines:latest
```

If Chroma is not running properly, manually login and run
```shell
sudo chroma run --path /app/chroma_prod --host localhost --port 3600
```



## Running the WebUI
```shell
sudo docker run -d -p 3000:8080 \
    --add-host=host.docker.internal:host-gateway \
    -v "transfusion-webui:/app/backend/data" \
    --name "open-webui" \
    --restart always \
    -e WEBUI_NAME="Dhanvantri AI" \
    buntha/transfusion-webui:latest
```

## Prompt Setup
```shell
	"version": 0,
	"ui": {
		"default_locale": "en-US",
		"prompt_suggestions": [
			{
				"title": [
					"Is transfusion needed for a stable 45-year-old with 800 ml blood loss",
					"Hb 7 gm/dl, and 80,000/\u00b5l platelets pre-surgery?"
				],
				"content": "Is transfusion needed for a stable 45-year-old with 800 ml blood loss, Hb 7 gm/dl, and 80,000/\u00b5l platelets pre-surgery? How many units?"
			},
			{
				"title": [
					"Need a packed red cell transfusion",
					"Does a stable 45-year-old, 70 kg patient with 8 gm/dl Hb who lost 600 ml blood during tibia surgery"
				],
				"content": "Does a stable 45-year-old, 70 kg patient with 8 gm/dl Hb who lost 600 ml blood during tibia surgery need a packed red cell transfusion? If so, how many units?"
			},
			{
				"title": [
					"How does the cross-matching process ensure compatibility",
					"between donor and recipient blood types to prevent"
				],
				"content": "How does the cross-matching process ensure compatibility between donor and recipient blood types to prevent transfusion reactions?"
			},
			{
				"title": [
					"Indications for Blood Transfusion:",
					"What are the primary clinical indications for performing a blood transfusion"
				],
				"content": "What are the primary clinical indications for performing a blood transfusion in patients with different medical conditions?"
			},
			{
				"title": [
					"How does the storage duration and conditions of blood products ",
					"impact their efficacy and safety for transfusion"
				],
				"content": "How does the storage duration and conditions of blood products impact their efficacy and safety for transfusion?"
			},
			{
				"title": [
					"What are the potential long-term complications",
					"associated with repeated blood transfusions, and how can they be mitigated?"
				],
				"content": "What are the potential long-term complications associated with repeated blood transfusions, and how can they be mitigated?"
			}
		]
	},
```

## Nginx Site Configuration

`nano /etc/nginx/sites-available/dhanvantriai.com`

```shell                                                                                     /etc/nginx/sites-available/dhanvantriai.com
server {
    listen 80;
    listen [::]:80;
    server_name dhanvantriai.com www.dhanvantriai.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
## Add Static Website

### Add About us page

1. Copy the file from `personal/aboutus.html` to /var/www/html/aboutus.html
2. Update the Nginx configuration to serve the static page

```shell
server {
    listen 80;
    listen [::]:80;
    server_name dhanvantriai.com www.dhanvantriai.com;

    root /var/www/html;

    location = /aboutus {
        try_files /aboutus.html =404;
        types { text/html html; }
        default_type text/html;
    }


    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
