classdef mosfet < handle
	properties (SetAccess = immutable)
		W % width
		L % length
		ro
		gm
		gmb
        gmp % gm-prime := gm' = gm + gmb
		Cgs
		Cgd
		is_nmos
	end
	properties
		Csb
		Cdb
        sat_mode % todo set
	end
	methods
		% constructor
		function M = mosfet(W,L,Id,np)
            % Constants
            lam = 0.1; % lambda', ie lambda = lambda' / length
            Cov = 0.5e-9; % Cov'=0.5fF/um, Cov=Cov'*W;
            Vt0 = 0.5;
            kp = 50e-6; % 50 uA/V^2
            Cox = 2.3e-3;

			M.W = W;
			M.L = L;
			M.ro = L/(lam*Id);
			M.gm = sqrt(2*kp*(W/L)*Id);
			M.gmb = 0.2*M.gm;
            M.gmp = M.gm + M.gmb;
			M.Cgs = 2/3*W*L*Cox+W*Cov;
            M.Cgd = W*Cov;
			M.is_nmos = true;
			if (nargin == 4) & (np == 'p')
				M.is_nmos = false;
			end
		end
		function setCJ(vsb,vdb)
            % Junction capcitance calculations
            Ldiff = 3e-6; % junction capacitances
            n_CJ = 0.1e-3; % 0.1 fF/um^2
            n_CJSW = 0.5e-9; % 0.5 fF/um
            p_CJ = 0.3e-3;
            p_CJSW = 0.35e-9;
            MJ = 0.5;
            MJSW = 0.33;
            PB = 0.95;

            AS = W*Ldiff;
            PS = W+2*Ldiff;
            if is_nmos
                CJ = n_CJ;
                CJSW = n_CJSW;
            else
                CJ = p_CJ;
                CJSW = p_CJ;
            end
			Csb = AS*CJ/(1+vsb/PB)^MJ + PS*CJSW/(1+vsb/PB)^MJ;
			Cdb = AS*CJ/(1+vdb/PB)^MJ + PS*CJSW/(1+vdb/PB)^MJ;
        end
    end
end

