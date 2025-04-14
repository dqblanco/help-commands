<?php
$idioma = isset($_GET['lang']) ? $_GET['lang'] : 'es';
$frases = ['es' => 'Bienvenido', 'en' => 'Welcome', 'fr' => 'Bienvenue'];
echo $frases[$idioma];