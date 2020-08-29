from django.test import TestCase, Client
from django.contrib.auth import get_user_model
from django.urls import reverse  # to generate urls for our Django admin page


class AdminSiteTests(TestCase):

    def setUp(self):
        # set things up before test. Create new user that logged in
        self.client = Client()
        self.admin_user = get_user_model().objects.create_superuser(
            email='admin@tarektest.com',
            password='password123'
        )
        self.client.force_login(self.admin_user)
        # logs in user without manually logging in
        self.user = get_user_model().objects.create_user(
            email='test@tarektest.com',
            password='password123',
            name='Test user full name'
        )

    def test_users_listed(self):
        """Test that users are listed on user page"""
        url = reverse('admin:core_user_changelist')
        # generates a url for our user list page
        res = self.client.get(url)  # res short for response

        self.assertContains(res, self.user.name)
        self.assertContains(res, self.user.email)

    def test_user_change_page(self):
        """Test that user edit page works"""
        url = reverse('admin:core_user_change', args=[self.user.id])
        res = self.client.get(url)

        self.assertEqual(res.status_code, 200)

    def test_create_user_page(self):
        """Test that the create user page works"""
        url = reverse('admin:core_user_add')
        res = self.client.get(url)

        self.assertEqual(res.status_code, 200)
