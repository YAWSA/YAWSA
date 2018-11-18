<?php

class ManagerAcceptanceCest

{

    public $id;

    protected $data = [];

    public function _data()
    {
        $this->data['route'] = \Helper::faker()->text(10);
        $this->data['title'] = \Helper::faker()->text(10);
    }

    public function _before(AcceptanceTester $I)
    {
        Helper::login($I);
    }

    public function _after(AcceptanceTester $I)
    {}

    public function IndexWorks(AcceptanceTester $I)
    {
        $I->amOnPage('/seo/manager/index');
        $I->canSeeResponseCodeIs(200);
        $I->seeElement('.grid-view');
        $this->_data();
    }

    public function AddFormCanBeSubmittedEmpty(AcceptanceTester $I)
    {
        $I->amOnPage('/seo/manager/add');
        $I->seeElement('#seo-form');
        $I->amGoingTo('add form without credentials');
        $I->click('#seo-form-submit');
        $I->canSeeResponseCodeIs(200);
        $I->expectTo('see validations errors');
        $req = $I->grabMultiple('.required');
        $count = count($req);
        $I->seeNumberOfElements('.has-error', $count);
    }

    public function AddWorksWithData(AcceptanceTester $I)
    {
        $I->amOnPage('/seo/manager/add');
        $I->seeElement('#seo-form');
        $I->amGoingTo('add form with right data');
        $I->fillField('Seo[route]', $this->data['route']);
        $I->fillField('Seo[title]', $this->data['title']);
        $I->click('#seo-form-submit');
        $I->canSeeResponseCodeIs(200);
        $I->dontseeElement('#manager-form');
        $I->see('Managers', 'h1');
        $I->seeElement('.table-bordered');
        $this->id = $I->grabFromCurrentUrl('/[=\/](\d+)/');
    }

    public function ViewWorks(AcceptanceTester $I)
    {
        $I->amOnPage('/seo/manager/' . $this->id);
        $I->amGoingTo('View manager details');
        $I->canSeeResponseCodeIs(200);
        $I->see('Managers', 'h1');
        $I->seeElement('.table-bordered');
    }

    public function UpdateWorks(AcceptanceTester $I)
    {
        $I->amOnPage('/seo/manager/update?id=' . $this->id);
        $I->seeElement('#seo-form');
        $I->amGoingTo('add form with right data');
        $I->fillField('Seo[route]', $this->data['route']);
        $I->fillField('Seo[title]', $this->data['title']);
        $I->click('#seo-form-submit');
        $I->canSeeResponseCodeIs(200);
        $I->dontseeElement('#manager-form');
        $I->see('Managers', 'h1');
        $I->seeElement('.table-bordered');
    }

    public function DeleteWorks(AcceptanceTester $I)
    {
        $I->sendAjaxPostRequest('/seo/manager/delete?id=' . $this->id);
        $I->expectTo('delete manager works');
        $I->amOnPage('/seo/manager/view?id=' . $this->id);
        $I->canSeeResponseCodeIs(404);
    }
}
