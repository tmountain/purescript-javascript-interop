const Main = require('./main');
const app = Main.mkSporkApp("#app");

export function incCount () {
    app.inc();
    app.run();
}

export function decCount () {
    app.dec();
    app.run();
}
