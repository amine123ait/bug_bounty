from discord_webhook import DiscordWebhook

webhook = DiscordWebhook(url='https://discord.com/api/webhooks/855593834317348874/ESdkQ2MgGPP2LusrMs9Fd2mQDCxPJGDzGBZFjH_tyq9aCP1Ei6MuAPImGsXza__9GEsI', username="FILE transfer")

# send two images
path="/home/projects/enum-bot-1/txt2pdf.py"
with open(path, "rb") as f:
    webhook.add_file(file=f.read(), filename='example.jpg')
with open("/home/projects/enum-bot-1/test", "rb") as f:
    webhook.add_file(file=f.read(), filename='example2.jpg')

response = webhook.execute()

