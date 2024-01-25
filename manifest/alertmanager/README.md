alertmanagerconfig-slack requires webhook for posting to Slack. Once webhook is generated in Slack, store it in a secret with command:

```bash
kubectl create secret generic slack-webhook -n prometheus --from-literal=apiSecret=YOUR_WEBHOOK_URL_HERE
```
