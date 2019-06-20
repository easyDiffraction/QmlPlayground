function randomHello() {
    const hello = ["Hello World", "Hallo Welt", "Hei maailma", "Hola Mundo"]
    return hello[Math.floor(Math.random() * hello.length)]
}
