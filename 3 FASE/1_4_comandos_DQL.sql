SELECT
    c.cd_categoria,
    c.ds_categoria,
    COUNT(s.nr_sac) AS Qnt_atendimento_realizado 
FROM
    mc_categoria_prod c
LEFT JOIN
    mc_produto p ON c.cd_categoria = p.cd_categoria
LEFT JOIN
 mc_sgv_sac s ON p.cd_produto = s.cd_produto
GROUP BY
    c.cd_categoria, c.ds_categoria
ORDER BY
    Qnt_atendimento_realizado DESC;