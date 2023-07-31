SerieTempporalSQL.sql

--Média da duração (em segundos) por Tipo Membro
SELECT avg(duracao_segundos /60  ) as media_duracao,tipo_membro
FROM exe5.tb_bikes
group by tipo_membro;


--Média da duração (em segundos) por Tipo Membro e por Estação Fim  
 SELECT avg(duracao_segundos /60  ) as media_duracao,estacao_fim,tipo_membro
FROM exe5.tb_bikes
group by tipo_membro,estacao_fim;


--Duração Acumulada (em segundos)
  SELECT estacao_fim,tipo_membro,duracao_segundos,
sum(duracao_segundos/60/60) over(partition by estacao_fim order by data_inicio) as duracao_acumulada
 from exe5.tb_bikes;


--Média de tempo (em horas) de aluguel de bike da estação de inicio "31017", ao longo do tempo (média móvel)
   SELECT numero_estacao_inicio,data_inicio,
avg(duracao_segundos/60/60) over(partition by estacao_inicio order by data_inicio) as media_movel
FROM exe5.tb_bikes
WHERE numero_estacao_inicio = '31017';


--Duração Total acumulada (em segundos)
--Média Movel (em segundos)
-- Quantidade Acumulada
--Sendo a data de inicio menor que "2012-01-08"
SELECT estacao_inicio,data_inicio,
sum(duracao_segundos/60/60) over(partition by estacao_inicio order by data_inicio) duracao_total_acumulada,
avg(duracao_segundos/60/60) over(partition by estacao_inicio order by data_inicio) media_acumulada,
count(data_inicio/60/60) over (partition  by estacao_inicio order by data_inicio) quantidade_acumulada
 FROM exe5.tb_bikes
 where data_inicio < '2012-01-08';


--Quantidade acumulada da bike "W01182"
 SELECT data_inicio,numero_bike,
count(duracao_segundos) over(partition by numero_bike order by data_inicio) as quantidade_Acumulada
 FROM exe5.tb_bikes
 where numero_bike ='W01182';


--Quantidade acumulada (em segundos) do mês de abril
   SELECT estacao_fim,data_fim,extract(month from data_fim) as mes_abril,
count(duracao_segundos) over(order by data_fim) as quantidade
 FROM exe5.tb_bikes
 where extract(month from data_fim)= 04;

 

--Formatar a data para achar a duração total (em segundos)
--Onde a data fim estar entre o dia 1 e 2 no mês de abril de 2012
   select * from (SELECT 
estacao_fim,duracao_segundos,cast(data_fim as date) as data_fim ,extract(day from data_fim) as dia ,
sum(duracao_Segundos/60/60) over(partition by estacao_fim order by cast(data_fim as date)) as duracao_total
 FROM exe5.tb_bikes
where data_fim between '2012-04-01' and '2012-04-02') resultado
where resultado.duracao_total >35;