Environment env;
Command cmd;

float phase = 1;

void setup() {
    size(1200, 600);
    
    env = new Environment();
    cmd = new Command();
}

void draw() {
    env.initialize();

    // -------------------------------------------------------------------------
    // ------------------------- Controller design -----------------------------
    // -------------------------------------------------------------------------

    // First phase: fixed thrust, towards the destination
    if (phase == 1) {
        cmd.setThrustCommand(0.5);
        cmd.setThrustAngleCommand(0.01 * (PI/6 - env.getStarshipAngle()));
    }

    // Second phase: getting closer... reduce angle to reduce x-axis velocity
    // and start reducing altitude
    if (abs(env.getStarshipXPosition() - env.getDestinationX()) < 100 &&
            phase == 1) {
        phase = 2;
    }
    if (phase == 2) {
        cmd.setThrustAngleCommand(0.01 * (min(PI/16,
            env.getStarshipXPosition() * PI/180) - env.getStarshipAngle()));
        cmd.setThrustCommand(0.75 * (env.getDestinationY() -
            env.getStarshipYPosition()));
    }

    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------

    // Update
    env.updateStarship(cmd);
}
