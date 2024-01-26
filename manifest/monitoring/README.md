AlertmanagerConfig requires a webhook for posting to Slack.

Create a webhook [https://api.slack.com/messaging/webhooks](https://api.slack.com/messaging/webhooks) and store the webhook URL in a secret for the AlertmanagerConfig to access:

```bash
kubectl create secret generic slack-webhook -n monitoring --from-literal=apiSecret=YOUR_WEBHOOK_URL_HERE
```
