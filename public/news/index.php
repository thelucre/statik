<?php
	include( __DIR__ . '/../partials/content.php');

	global $meta;
	$meta = $news['meta'];

	include( __DIR__ . '/../partials/header.php');
?>

<div class="posts">
  <h3><?= $news['title'] ?></h3>

  <? foreach($news['posts'] as $post) { ?>

    <div class="post">
      <p><strong><?= $post['title'] ?></strong> - <?= $post['date'] ?></p>
      <?= $post['content'] ?>
    </div>

  <? } ?>
</div>


<?php include (__dir__ . '/../partials/footer.php'); ?>
