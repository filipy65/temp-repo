#!/usr/bin/perl
use strict;
use warnings;

# Bibliotecas externas
use Text::CSV;
use Try::Tiny;
use File::Slurp;

# Nome do arquivo
my $arquivo = 'dados.csv';

# Inicializa CSV handler
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

# Leitura segura do arquivo
my @linhas;
try {
    @linhas = read_file($arquivo, chomp => 1);
} catch {
    warn "Erro ao ler o arquivo: $_";
};

# Converte linhas CSV para arrays
my @dados;
foreach my $linha (@linhas) {
    if ($csv->parse($linha)) {
        push @dados, [$csv->fields()];
    }
}

# Adiciona novo registro
my @novo_registro = ("Fulano", 30);
push @dados, \@novo_registro;

# Converte de volta para CSV
my @linhas_atualizadas;
foreach my $linha_ref (@dados) {
    if ($csv->combine(@$linha_ref)) {
        push @linhas_atualizadas, $csv->string();
    }
}

# Escreve no arquivo
try {
    write_file($arquivo, { atomic => 1 }, join("\n", @linhas_atualizadas) . "\n");
    print "Arquivo atualizado com sucesso!\n";
} catch {
    warn "Erro ao escrever no arquivo: $_";
};
