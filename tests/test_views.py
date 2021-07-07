# -*- coding: utf-8 -*-

import pytest

from ckeditor_emencia.views import EditorTemplatesListView
from ckeditor_emencia.models import CKEditorTemplate


@pytest.fixture
def template_list():
    return []


@pytest.fixture
def etlv(template_list, rf):
    view = EditorTemplatesListView.as_view(
        template_list=template_list,
    )

    def request_etlv():
        return view(rf.get('/'))
    return request_etlv


def test_none(etlv):
    resp = etlv()
    assert resp.status_code == 200
    assert resp.content.decode('utf-8') == '''CKEDITOR.addTemplates('default', {
    imagesPath: '/static/',
    templates: []
});'''


def test_one(template_list, etlv):
    template_list.append(CKEditorTemplate('test', 'testity', 'test.png', '<p>test</p>'))

    resp = etlv()
    assert resp.status_code == 200
    assert resp.content.decode('utf-8') == '''CKEDITOR.addTemplates('default', {
    imagesPath: '/static/',
    templates: [{"title": "test", "description": "testity", "image": "test.png", "html": "<p>test</p>"}]
});'''
