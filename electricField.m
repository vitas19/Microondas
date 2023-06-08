function E=electricField(ri,rt,qi)
c=299792458; % Speed of light (m/s)
ke=c^2/1e7;  % Coulomb constant (Nm^2/C^2)
r = norm(rt-ri);
u = (rt-ri)/r; % Unitary vector of distance in Cartesian coordinates
E = ke*qi/r^2 * u; % Electric field (E)
end