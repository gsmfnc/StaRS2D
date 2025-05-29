Environment env;
Command cmd;

void setup() {
    size(1200, 600);
    
    env = new Environment();
    cmd = new Command();
}

void draw() {
    env.initialize(); // must return starship infos

    // -------------------------------------------------------------------------
    // ------------------------- Controller design -----------------------------
    // -------------------------------------------------------------------------

    // First phase: fixed thrust, towards the destination
    cmd.setThrustCommand(0.5);
    cmd.setThrustAngleCommand(0.1 * (PI/6 - env.getStarshipAngle()));

    // Second phase: getting closer... reduce angle to reduce x-axis velocity
    if (abs(env.getStarshipXPosition() - env.getDestinationX()) < 30)
        cmd.setThrustAngleCommand(0.1 * (PI/30 - env.getStarshipAngle()));

    // Third phase: practically above the destination so null starship angle and
    // reduce thrust to reduce altitude
    if (abs(env.getStarshipXPosition() - env.getDestinationX()) < 1) {
        cmd.setThrustAngleCommand(-env.getStarshipAngle());
        cmd.setThrustCommand(0.1 * (env.getDestinationY() -
            env.getStarshipYPosition()));
    }
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------

    // Update
    env.updateStarship(cmd);
}
