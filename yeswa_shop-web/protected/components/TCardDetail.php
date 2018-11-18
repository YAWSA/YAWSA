<?php
namespace app\components;


/**
 *          echo TCardDetail::widget([
 *   		    'link' => 'login-history/index',
 *   		    'icon' => 'users',
 *  		    'data' => LoginHistory::find ()->count (),
 *  		    'title' => 'Login History'
 *  		])
 */

use yii\helpers\Url;

class TCardDetail extends TBaseWidget
{
    public $visible = true;
    public $link ;
    public $template = 'col-lg-3 col-sm-6';
    public $data;
    public $icon = 'file';
    public $title = '';
    

    public function renderHtml()
    {
        if ($this->visible == false)
            return;
        
        ?>
        <a href="<?= Url::toRoute([$this->link]);?>">
			<div class="<?= $this->template?>">
				<section class="panel">
					<div class="symbol">
						<i class="fa fa-<?= $this->icon?>"></i>
					</div>
					<div class="value white">
						<h1><?= $this->data?></h1>
						<p><?= $this->title?></p>
					</div>
				</section>
			</div>
		</a>
		<?php 
    }
}