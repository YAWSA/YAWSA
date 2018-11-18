<?php
use app\assets\AppAsset;
use app\components\FlashMessage;
use app\models\User;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\widgets\Breadcrumbs;
use yii\widgets\Menu;

$user = Yii::$app->user->identity;

/* @var $this \yii\web\View */
/* @var $content string */
// $this->title = yii::$app->name;

AppAsset::register($this);
?>
<?php

$this->beginPage()?>
<!DOCTYPE html>
<html lang="<?=Yii::$app->language?>">
<head>
<meta charset="<?=Yii::$app->charset?>" />
    <?=Html::csrfMetaTags ()?>
    <title><?=Html::encode ( $this->title )?></title>
    <?php
    
    $this->head()?>
    <meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

<link rel="shortcut icon"
	href="<?=$this->theme->getUrl ( 'img/' )?>"
	type="image/png">


<!--common style-->
<link
	href="<?php echo $this->theme->getUrl('css/style-admin-'. $this->theme->style . '.css')?>"
	rel="stylesheet">




<link
	href="<?php

echo $this->theme->getUrl('css/style-responsive.css')?>"
	rel="stylesheet">
<!--theme color layout-->


<link href="<?php echo $this->theme->getUrl('css/layout-theme-two-'. $this->theme->style . '.css')?>" rel="stylesheet">


<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
    <script src="js/respond.min.js"></script>
    <![endif]-->
</head>
<body class="sticky-header">
<?php

$this->beginBody();

if (! User::isGuest()) :
    ?>

    <section>
		<!-- sidebar left start-->
		<div class="sidebar-left">
			<!--responsive view logo start-->
			<div class="logo theme-logo-bg visible-xs-* visible-sm-*">
				<a href="<?php
    
    echo Url::home();
    ?>"> <span class="brand-name"><?=Html::encode ( \yii::$app->name )?></span>
				</a>
			</div>
			<!--responsive view logo end-->

			<div class="sidebar-left-info">
				<!-- visible small devices start-->
				<div class=" search-field"></div>
				<!-- visible small devices start-->

				<!--sidebar nav start-->
		<?php
    
    if (method_exists($this->context, 'renderNav')) {
        ?>
			<?= Menu::widget ( [ 'encodeLabels' => false,'activateParents' => true,'items' => $this->context->renderNav (),'options' => [ 'class' => 'nav  nav-stacked side-navigation' ],'submenuTemplate' => "\n<ul class='child-list'>\n{items}\n</ul>\n" ] );?>
	<?php
    }
    ?>
		<!--sidebar nav end-->

			</div>
		</div>
		<!-- sidebar left end-->

		<!-- body content start-->
		<div class="body-content">

			<!-- header section start-->
			<div class="header-section bg-danger light-color">

				<!--logo and logo icon start-->
				<div class="logo theme-logo-bg hidden-xs hidden-sm">
					<a href="<?php
    
    echo Url::home();
    ?>"> <!--<i class="fa fa-maxcdn"></i>--> <span class="brand-name"><?=Html::encode ( \yii::$app->name )?></span>
					</a>
				</div>


				<!--logo and logo icon end-->

				<!--toggle button start-->
				<a class="toggle-btn"><i class="fa fa-outdent"></i></a>
				<!--toggle button end-->

				<!--mega menu start-->

				<!--mega menu end-->
				<div class="notification-wrap">



					<!--right notification start-->
					<div class="right-notification">
						<ul class="notification-menu">
							<li>
    						<?php if (YII_ENV == 'dev') : ?>
    								<div class="label label-danger" role="alert">
									<strong> Warning! </strong> Development Mode is On.
								</div>
    						<?php endif; ?>
							</li>
							<li><span class="label label-primary" role="version"> Version <?= VERSION ?></span></li>


							<!-- <div class="navbar-text">
							  /* echo \lajax\languagepicker\widgets\LanguagePicker::widget ( [
							 		'skin' => \lajax\languagepicker\widgets\LanguagePicker::SKIN_BUTTON,
							 		'size' => \lajax\languagepicker\widgets\LanguagePicker::SIZE_LARGE

							 ]);
							 </div> -->
							<li><a href="javascript:;"
								class="btn btn-default dropdown-toggle" data-toggle="dropdown">

								<?= \Yii::$app->user->identity->displayImage(\Yii::$app->user->identity->profile_file, ['width' => '50', 'height' => '50', 'class' => '']); ?>
								
                                <?php echo Yii::$app->user->identity->full_name; ?>
                                <span class=" fa fa-angle-down"></span>
							</a>
								<ul class="dropdown-menu dropdown-usermenu purple pull-right">
									<li><a
										href="<?php
    
    echo Url::toRoute([
        '/user/view',
        'id' => Yii::$app->user->id
    ]);
    ?>"> <i class="fa fa-user pull-right"></i> Profile
									</a></li>
									<li><a
										href="<?php
    
    echo Url::toRoute([
        '/user/changepassword',
        'id' => Yii::$app->user->id
    ]);
    ?>"> <span class="fa fa-key pull-right"></span> <span>Change
												Password</span>
									</a></li>
									<li><a
										href="<?php
    
    echo Url::toRoute([
        '/user/update',
        'id' => Yii::$app->user->id
    ]);
    ?>"> <span class="fa fa-pencil pull-right"></span> Update
									</a></li>
									<li><a
										href="<?php
    
    echo Url::toRoute([
        '/user/logout'
    ]);
    ?>"> <i class="fa fa-sign-out pull-right"></i> Log Out
									</a></li>
								</ul></li>


						</ul>
					</div>
					<!--right notification end-->
				</div>
			</div>

			<!-- header section end-->

			<!-- page head start-->
			 <?=Breadcrumbs::widget ( [ 'links' => isset ( $this->params ['breadcrumbs'] ) ? $this->params ['breadcrumbs'] : [ ] ] )?>
			<!--body wrapper start-->
			<section class="main_wrapper">
				
				<?php
    if (yii::$app->hasModule('shadow')) {
        echo app\modules\shadow\components\ShadowWidget::widget();
    }
    ?>
				
			
			
			   <?= FlashMessage::widget (['type' => 'notify', /*'position' => 'bottom-right'*/  ]) ?>
			   			   
               <?=$content; ?>

			</section>

			<footer>

				<div class="row text-center">
					<p target="_blank">
					<?php echo ' &copy; ' . date ( 'Y' ) . ' ' . Yii::$app->name . ' | All Rights Reserved '; ?></p>
					<p class="hosting m-t-10">
						Hosting Partner <a href="https://jiwebhosting.com/"
							target="_blank">jiWebHosting.com</a>
					</p>
				</div>
			</footer>
			<!--body wrapper end-->
		</div>
		<!-- body content end-->

	</section>

	
	<script src="<?php echo $this->theme->getUrl ( 'js/scripts.js' )?>"></script>

	<script src="<?php echo $this->theme->getUrl ( 'js/custom.js' ) ?>"></script>
<?php
endif;

$this->endBody();
?>


</body>
<script type="text/javascript">
$(document).ready(function(){
	$(".child-list").find('span').contents().unwrap();
});
</script>

<?php

$this->endPage()?>
</html>