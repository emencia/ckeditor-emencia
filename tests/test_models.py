# -*- coding: utf-8 -*-

from ckeditor_emencia.models import TemplateList, CKEditorTemplate


def test_template_list_empty():
    assert list(TemplateList()) == []


def test_template_default(settings):
    settings.INSTALLED_APPS = [
        'ckeditor_emencia',
    ]

    assert list(TemplateList())


def test_template_list_test_app(settings):
    settings.INSTALLED_APPS = [
        'tests.test_app',
    ]

    assert set(TemplateList()) == {
        CKEditorTemplate('test title 123', 'test description 456', 'test-image.png', '<p>test.html</p>\n'),
        CKEditorTemplate(title='not_in_manifest.html', description='',
                         image='', html='<strong>not in manifest</strong>\n'),
    }


def test_template_list_no_manifest(settings):
    settings.INSTALLED_APPS = [
        'tests.test_no_manifest',
    ]

    assert list(TemplateList()) == [
        CKEditorTemplate(title='test.html', description='', image='', html='<p>no manifest</p>\n'),
    ]
