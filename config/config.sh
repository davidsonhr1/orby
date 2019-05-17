sudo chmod go-w /usr/local/orby/**

export BLUESOFT_TABLEAU_PATH=/Users/davidson/Documents/workspace/bluesoft-tableau/workbooks/production/
export PATH=$PATH:BLUESOFT_TABLEAU_PATH
export PYTHONWARNINGS=ignore::yaml.YAMLLoadWarning
export NLS_LANG=AMERICAN_AMERICA.UTF8
alias orby='ruby /usr/local/orby/orby.rb'