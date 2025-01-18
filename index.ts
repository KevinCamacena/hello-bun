import figlet from "figlet";

const server = Bun.serve({
  port: 8080,
  fetch(req) {
    const body = figlet.textSync(
      "Hello Bun!"
    );
    return new Response(body);
  },
});

console.log(`Listening on http://localhost:${server.port} ...`);
