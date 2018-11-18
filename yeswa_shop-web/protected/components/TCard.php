<?php
namespace app\components;

use yii\helpers\Html;
use yii\base\Widget;
use yii\helpers\Url;

/** *
 * For example,
 *
 * ```php
 * echo Card::widget([
 * 'title' => 'Title',
 * 'content' => 'Content',
 * ]);
 * ```
 */
class TCard extends Widget
{
    
    public $icon = 'file';

    public $title;

    public $content;

    public $action;

    public $visible = true;
    
    public $defaultClass = 'col-lg-3';

    public $clientOptions = '';

    public $options;

    public function init()
    {
        parent::init();
        $this->clientOptions = false;
        if ($this->defaultClass)
            Html::addCssClass($this->options, $this->defaultClass);
    }

    public function run()
    {
        if ($this->visible == false)
            return;
        // return Html::tag($this->tagName, $this->encodeLabel ? Html::encode($this->label) : $this->label, $this->options);
        $html = '';
        $html .= $this->beginAction();
        $html .= $this->beginSection();
        if ($this->icon !== null) {
            $html .= $this->renderIcon();
        }
        if ($this->content !== null) {
            $html .= Html::beginTag('div', [
                'class' => 'value white'
            ]);
            $html .= $this->renderContent();
            $html .= $this->renderTitle();
            $html .= Html::endTag('div');
        }
        $html .= $this->endSection();
        $html .= $this->endAction();
        if ($this->defaultClass) {
            Html::addCssClass($this->options, $this->defaultClass);
        }
        return Html::tag('div', $html, $this->options);
    }

    public function beginSection()
    {
        return Html::beginTag('section', [
            'class' => 'panel'
        ]);
    }

    public function endSection()
    {
        return Html::endTag('section');
    }

    public function renderTitle()
    {
        return Html::tag('p', $this->title, [
            'class' => ''
        ]);
    }

    public function beginAction()
    {
        return Html::beginTag('a', [
            'href' => Url::to([
                $this->action
            ])
        ]);
    }

    public function endAction()
    {
        return Html::endTag('a');
    }

    public function renderIcon()
    {
        $html = Html::beginTag('i', [
            'class' => "fa fa-$this->icon"
        ]);
        $html .= Html::endTag('i');
        return Html::tag('div', $html, [
            'class' => 'symbol'
        ]);
    }
    public function renderContent()
    {        
        return Html::tag('H1', $this->content);
    }
}
