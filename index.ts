import figlet from "figlet";

const server = Bun.serve({
  port: 8080,
  hostname: '0.0.0.0',
  fetch(req) {
    const body = figlet.textSync(
      "Hello Bun!\nNow running with ArgoCD\nand Kubernetes"
    );
    return new Response(body);
  },
});

console.log(`Listening on http://0.0.0.0:${server.port} ...`);
