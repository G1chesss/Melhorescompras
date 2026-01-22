SET SERVEROUTPUT ON;

DECLARE
    -- Desafio 1 (a)
    CURSOR c_sac_dados IS
        SELECT
            s.nr_sac,
            s.dt_abertura_sac,
            s.hr_abertura_sac,
            s.tp_sac,
            p.cd_produto,
            p.ds_produto,                
            p.vl_unitario,                
            p.vl_perc_lucro,              
            c.nr_cliente,             
            c.nm_cliente,                
            e.sg_estado,                 
            e.nm_estado                  
        FROM
            mc_sgv_sac s
            LEFT JOIN mc_produto p ON s.cd_produto = p.cd_produto
            LEFT JOIN mc_cliente c ON s.nr_cliente = c.nr_cliente
            LEFT JOIN mc_end_cli ec ON c.nr_cliente = ec.nr_cliente
            LEFT JOIN mc_logradouro l ON ec.cd_logradouro_cli = l.cd_logradouro
            LEFT JOIN mc_bairro b ON l.cd_bairro = b.cd_bairro
            LEFT JOIN mc_cidade ci ON b.cd_cidade = ci.cd_cidade
            LEFT JOIN mc_estado e ON ci.sg_estado = e.sg_estado;

BEGIN
    -- Desafio 1 (b)
    FOR rec IN c_sac_dados LOOP
        --Regra 4
        INSERT INTO MC_SGV_OCORRENCIA_SAC (
            NR_OCORRENCIA_SAC,
            DT_ABERTURA_SAC,
            HR_ABERTURA_SAC,
            DS_TIPO_CLASSIFICACAO_SAC, 
            CD_PRODUTO,
            DS_PRODUTO,
            VL_UNITARIO_PRODUTO,
            VL_PERC_LUCRO,
            VL_UNITARIO_LUCRO_PRODUTO,
            SG_ESTADO,
            NM_ESTADO,
            NR_CLIENTE,
            NM_CLIENTE,
            VL_ICMS_PRODUTO 
        )
        VALUES (
            rec.nr_sac,
            rec.dt_abertura_sac,
            rec.hr_abertura_sac,
            -- Regra 1
            CASE rec.tp_sac
                WHEN 'S' THEN 'SUGESTÃO'
                WHEN 'D' THEN 'DÚVIDA'
                WHEN 'E' THEN 'ELOGIO'
                ELSE 'CLASSIFICAÇÃO INVÁLIDA'
            END,
            rec.cd_produto,
            rec.ds_produto,
            rec.vl_unitario,
            rec.vl_perc_lucro,
            -- Regra 2
            (rec.vl_perc_lucro / 100) * rec.vl_unitario,
            rec.sg_estado,
            rec.nm_estado,
            rec.nr_cliente,
            rec.nm_cliente,
            NULL -- Regra 3: VL_ICMS_PRODUTO vazia 
        );

    END LOOP;

    -- Regra 5
    COMMIT;

END;
/