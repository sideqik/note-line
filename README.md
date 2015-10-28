# Getting Started

To setup project:

```sh
curl https://install.meteor.com/ | sh
meteor
```

### Don't start mongo twice

To prevent meteor from starting mongo twice, you can set a MONGO_URL environment variable like so:

```sh
MONGO_URL=mongodb://localhost:27017/noteline meteor run
```
