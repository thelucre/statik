<?php
// Build default array
$meta = (empty($meta)) ? [] : $meta;

$meta['title']       = (empty($meta['title'])) ? $global['meta']['title'] : $meta['title'];
$meta['description'] = (empty($meta['description'])) ? $global['meta']['description'] : $meta['description'];
$meta['image']       = (empty($meta['image'])) ? $global['meta']['image'] : $meta['image'];

// Add Global company title to tile string
$meta['title'] = ($meta['title'] != $global['meta']['title']) ?
$meta['title'] . ' | ' . $global['meta']['title'] : $meta['title'];

// Get domain to append to absolute image paths
$domain = 'http://' . $_SERVER['HTTP_HOST'];
?>


<?// Render meta tags ?>
<title><?= $meta['title'] ?></title>
<meta property="og:title" content="<?= $meta['title']; ?>">
<meta name="title" property="title" content="<?= $meta['title']; ?>">

<meta name="description" content="<?= $meta['description']; ?>">
<meta name="og:description" property="og:description" content="<?= $meta['description']; ?>">

<meta name="image" property="image" content="<?= $domain . $meta['image']?>">
<meta property="og:image" content="<?= $domain . $meta['image']?>" />
