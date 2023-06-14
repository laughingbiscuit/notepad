SESSION=$(curl localhost:9515/session -d '{
  "desiredCapabilities": {
  "browserName": "chromium",
    "chromeOptions": {
      "args": ["--no-sandbox", "--headless"]
    }
  }
}'| jq '.sessionId')
sleep 2
curl localhost:9515/session/$SESSION_ID/url -d '{"url":"http://httpbin.org/"}
sleep 2
curl localhost:9515/session/$SESSION_ID/screenshot | jq '.value' > screenshot.png
