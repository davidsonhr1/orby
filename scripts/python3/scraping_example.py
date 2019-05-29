import sys
import os
from os import path
sys.path.append(path.join(path.dirname(__file__), '../../bin/'))
from pycore import get_options
import scrapy
import array as arr
import pdb

class AbrasSpider(scrapy.Spider):
    name = "abras"
    start_urls = ['http://abrasnet.com.br/economia-e-pesquisa/indice-de-tiquete-medio/historico']

    def parse(self, response):
     self.log('Visitando o site: %s' % response.url)

     for dt in response.xpath("//div[@id='main']/div"):
        for tables in dt.xpath("//table/@id[contains(., "'hist'")]"):
            pos_ano_a = 3
            pos_ano_b = pos_ano_a+13
            table_name = tables.extract()

            title = f"//table[@id='{table_name}']/tbody/tr/td[1]/table/tbody/tr[1]/td/strong/text()"
            column = f"//table[@id='{table_name}']/tbody/tr/td[1]/table/tbody/tr[2]"
            columns = []

            for i in range(1,5):
                columns.append(dt.xpath(f"{column}/td[{i}]/text()").extract()[0])

            yield{
                'tabela': dt.xpath(title).extract()[0],
                'colunas': columns,
                'ano': dt.xpath(f"//table[@id='{table_name}']/tbody/tr/td[1]/table/tbody/tr[3]/td/strong/text()").extract()
            }

if get_options().generic_param == 'spider':
    os.system(f'scrapy runspider {__file__}')