function spin_stability()
    % Moment of inertia
    Ixx = 1; Iyy = 2; Izz = 3;

    % Select initial condition set (e.g., Plot 2: spin about intermediate axis)
    w0 = [0.2; 7; 0.2];  % [wx0; wy0; wz0]

    % Time span
    tspan = [0 4];

    % Solve ODE
    [t, w] = ode45(@(t, w) odefun(t, w, Ixx, Iyy, Izz), tspan, w0);

    % Plot
    plot(t, w)
    xlabel('Time (seconds)')
    ylabel('\omega (rad/s)')
    legend('\omega_x', '\omega_y', '\omega_z')
    title('Spin about Intermediate Axis')
end

function dw = odefun(~, w, Ixx, Iyy, Izz)
    wx = w(1); wy = w(2); wz = w(3);
    dwx = ((Iyy - Izz) * wy * wz) / Ixx;
    dwy = ((Izz - Ixx) * wz * wx) / Iyy;
    dwz = ((Ixx - Iyy) * wx * wy) / Izz;
    dw = [dwx; dwy; dwz];
end
