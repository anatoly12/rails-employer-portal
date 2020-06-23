
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `account_access_grants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_access_grants` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `partner_access_code_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_account_access_grants_on_account_id` (`account_id`),
  KEY `index_account_access_grants_on_partner_access_code_id` (`partner_access_code_id`)
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `account_demographics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_demographics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `full_legal_name` varchar(255) DEFAULT NULL,
  `state_of_residence` varchar(255) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `phone_number` varchar(30) DEFAULT NULL,
  `account_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_account_demographics_on_account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `agreed_to_age_at` datetime DEFAULT NULL,
  `agreed_to_tos_at` datetime DEFAULT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_accounts_on_email` (`email`),
  UNIQUE KEY `index_accounts_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_accounts_on_confirmation_token` (`confirmation_token`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_storage_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_attachments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `record_type` varchar(255) NOT NULL,
  `record_id` bigint(20) NOT NULL,
  `blob_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_attachments_uniqueness` (`record_type`,`record_id`,`name`,`blob_id`),
  KEY `index_active_storage_attachments_on_blob_id` (`blob_id`),
  CONSTRAINT `fk_rails_c3b3935057` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_storage_blobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_blobs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `metadata` text,
  `byte_size` bigint(20) NOT NULL,
  `checksum` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_blobs_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `admin_debug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_debug` (
  `debug_id` int(11) NOT NULL AUTO_INCREMENT,
  `level` varchar(255) DEFAULT NULL,
  `message` text,
  `created_on` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`debug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=516 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_daily_checkup_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_daily_checkup_statuses` (
  `daily_checkup_status_code` tinyint(4) NOT NULL,
  `daily_checkup_status` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`daily_checkup_status_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_daily_checkups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_daily_checkups` (
  `account_id` bigint(20) NOT NULL,
  `checkup_date` date NOT NULL,
  `daily_checkup_status_code` tinyint(4) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_id`,`checkup_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_evaluation_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_evaluation_statuses` (
  `status_code` bigint(20) NOT NULL,
  `status_enum` varchar(45) NOT NULL COMMENT 'in_progress: 0,physician_cleared_established_immunity: 1,physician_rejected: 2, patient_resolved: 3,\n			physician_cleared_low_likelihood: 4,physician_closed_additional_testing: 5',
  `status_text` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`status_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_evaluations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_evaluations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) DEFAULT NULL,
  `health_care_provider_id` bigint(20) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `rejection_code` int(11) DEFAULT NULL,
  `identity_approved` tinyint(1) DEFAULT NULL,
  `subjective_hpi_approved` tinyint(1) DEFAULT NULL,
  `lab_review_approved` tinyint(1) DEFAULT NULL,
  `assessment_notes` text,
  `pcr_result` int(11) DEFAULT NULL,
  `igm_result` int(11) DEFAULT NULL,
  `igg_result` int(11) DEFAULT NULL,
  `days_to_retest` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_covid19_evaluations_on_account_id` (`account_id`),
  KEY `index_covid19_evaluations_on_health_care_provider_id` (`health_care_provider_id`),
  KEY `index_covid19_evaluations_on_status` (`status`),
  KEY `index_covid19_evaluations_on_pcr_result` (`pcr_result`),
  KEY `index_covid19_evaluations_on_igm_result` (`igm_result`),
  KEY `index_covid19_evaluations_on_igg_result` (`igg_result`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_evaluations_acct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_evaluations_acct` (
  `covid19_evaluations_acct_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `covid19_evaluation_id` bigint(20) DEFAULT NULL,
  `account_id` bigint(20) DEFAULT NULL,
  `health_care_provider_id` bigint(20) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `rejection_code` int(11) DEFAULT NULL,
  `identity_approved` tinyint(1) DEFAULT NULL,
  `subjective_hpi_approved` tinyint(1) DEFAULT NULL,
  `lab_review_approved` tinyint(1) DEFAULT NULL,
  `assessment_notes` text,
  `pcr_result` int(11) DEFAULT NULL,
  `igm_result` int(11) DEFAULT NULL,
  `igg_result` int(11) DEFAULT NULL,
  `days_to_retest` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`covid19_evaluations_acct_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_evaluations_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_evaluations_updates` (
  `covid19_evaluations_update_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `covid19_evaluation_id` bigint(20) DEFAULT NULL,
  `health_care_provider_id` bigint(20) DEFAULT NULL,
  `field` varchar(40) DEFAULT NULL,
  `old_value` int(11) DEFAULT NULL,
  `new_value` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`covid19_evaluations_update_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_message_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_message_codes` (
  `message_code` int(11) NOT NULL AUTO_INCREMENT,
  `message_subject` varchar(255) NOT NULL,
  `message_copy` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_messages` (
  `covid19_message_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `message_code` int(11) NOT NULL,
  `resolved` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`covid19_message_id`),
  KEY `idx_covid19_messages_account_id` (`account_id`),
  CONSTRAINT `fk_covid19_messages_account_id` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_rejection_reason_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_rejection_reason_codes` (
  `rejection_reason_code` int(3) NOT NULL,
  `rejection_code_enum` varchar(45) NOT NULL COMMENT 'identification_expired: 0,\n        date_of_birth_mismatch: 1,\n        current_selfie: 2,\n        unclear_selfie: 3,\n        timeline: 4,\n        lab_identity_mismatch: 5,\n        incorrect_lab_test: 6,\n        lab_test_illegible: 7,\n        unclear_identification: 8',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rejection_reason_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_rejection_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_rejection_reasons` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `covid19_evaluation_id` bigint(20) DEFAULT NULL,
  `rejection_code` int(11) DEFAULT NULL,
  `description` text,
  `resolved` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_covid19_rejection_reasons_on_covid19_evaluation_id` (`covid19_evaluation_id`),
  KEY `index_covid19_rejection_reasons_on_rejection_code` (`rejection_code`),
  CONSTRAINT `fk_rails_689db30a5c` FOREIGN KEY (`covid19_evaluation_id`) REFERENCES `covid19_evaluations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_test_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_test_results` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `covid19_test_id` bigint(20) NOT NULL,
  `persisted_s3_key` varchar(255) DEFAULT NULL,
  `uploaded` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_covid19_test_results_on_covid19_test_id` (`covid19_test_id`)
) ENGINE=InnoDB AUTO_INCREMENT=459 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `covid19_tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `covid19_tests` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_covid19_tests_on_account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_attachments` (
  `attachment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `attachment` mediumblob,
  `object_type` varchar(45) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`attachment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_chord_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_chord_categories` (
  `chord_category_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category` varchar(45) NOT NULL,
  `category_type` varchar(45) DEFAULT NULL,
  `color` varchar(7) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`chord_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_chord_categories_t_question_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_chord_categories_t_question_map` (
  `chord_category_id` bigint(20) NOT NULL,
  `t_question_id` bigint(20) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`chord_category_id`,`t_question_id`,`gender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_chord_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_chord_data` (
  `chord_data_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chord_data` mediumtext,
  `category_type` varchar(45) DEFAULT NULL,
  `kit_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`chord_data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1308 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_clinic_physician_partner_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_clinic_physician_partner_map` (
  `partner_id` int(11) DEFAULT NULL,
  `clinic_physician_id` int(11) DEFAULT NULL,
  KEY `clinic_phys_partner_map_idx1` (`partner_id`,`clinic_physician_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_clinic_physicians`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_clinic_physicians` (
  `clinic_physician_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(40) DEFAULT NULL,
  `license` varchar(45) DEFAULT NULL,
  `npi` int(10) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`clinic_physician_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_coach_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_coach_comments` (
  `coach_comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coach_session_id` bigint(20) DEFAULT NULL,
  `comment` text,
  `status` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`coach_comment_id`),
  KEY `coach_comment_sessions_fk_idx` (`coach_session_id`),
  CONSTRAINT `coach_comment_sessions_fk` FOREIGN KEY (`coach_session_id`) REFERENCES `ec_coach_sessions` (`coach_session_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='List of tests cited by coach for discussion during telemedicine session. Pushed to partner e.g. Hale.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_coach_comments_tests_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_coach_comments_tests_map` (
  `coach_comment_id` int(11) DEFAULT NULL,
  `test_id` int(11) DEFAULT NULL,
  KEY `coachcomments_tests_map_key1` (`coach_comment_id`,`test_id`),
  KEY `coachcomments_tests_idx1` (`coach_comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_coach_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_coach_sessions` (
  `coach_session_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `partner_id` bigint(20) DEFAULT NULL,
  `scheduled_start` datetime DEFAULT NULL,
  `session_start` datetime DEFAULT NULL,
  `session_stop` datetime DEFAULT NULL,
  `session_notes` text,
  `status` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`coach_session_id`),
  KEY `telemed_sessions_users_fk_idx` (`user_id`),
  KEY `telemed_session_partners_fk_idx` (`partner_id`),
  CONSTRAINT `telemed_session_partners_fk` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `telemed_sessions_users_fk` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_coach_sessions_ptnr_clinicallabdata_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_coach_sessions_ptnr_clinicallabdata_map` (
  `coach_session_id` bigint(20) NOT NULL,
  `clinicallabdata_id` bigint(20) NOT NULL,
  PRIMARY KEY (`coach_session_id`,`clinicallabdata_id`),
  KEY `IDX_coach_sessions_ptnr_clinicallabdata_map_clinicallabdata` (`clinicallabdata_id`),
  CONSTRAINT `FK_coach_sessions_clinicallabdata_labdata` FOREIGN KEY (`clinicallabdata_id`) REFERENCES `ptnr_clinicallabdata` (`clinicallabdata_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_coach_sessions_clinicallabdata_session` FOREIGN KEY (`coach_session_id`) REFERENCES `ec_coach_sessions` (`coach_session_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_comments` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `comment` text,
  `object_type` varchar(45) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_config` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `variable` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_data_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_data_types` (
  `data_type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `type_of` varchar(45) DEFAULT NULL,
  `list_id` int(11) DEFAULT NULL,
  `min_value` int(11) DEFAULT NULL,
  `max_value` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`data_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_health_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_health_modules` (
  `health_module_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_health_module_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`health_module_id`),
  KEY `FK_ec_health_modules_t_health_module_id` (`t_health_module_id`),
  KEY `FK_ec_health_modules_user_id` (`user_id`),
  CONSTRAINT `FK_ec_health_modules_t_health_module_id` FOREIGN KEY (`t_health_module_id`) REFERENCES `ec_t_health_modules` (`t_health_module_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_health_modules_user_id` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=1260;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_health_modules_requisitions_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_health_modules_requisitions_map` (
  `health_module_id` bigint(20) NOT NULL,
  `requisition_id` bigint(20) NOT NULL,
  PRIMARY KEY (`health_module_id`,`requisition_id`),
  KEY `IDX_ec_health_modules_requisitions_map_requisition_id` (`requisition_id`),
  CONSTRAINT `FK_ec_health_modules_requisitions_map_health_module_id` FOREIGN KEY (`health_module_id`) REFERENCES `ec_health_modules` (`health_module_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_health_modules_requisitions_map_requisition_id` FOREIGN KEY (`requisition_id`) REFERENCES `ec_requisitions` (`requisition_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=1170;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_kit_audit_trail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_kit_audit_trail` (
  `kit_audit_trail_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kit_id` bigint(20) NOT NULL,
  `status` varchar(45) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`kit_audit_trail_id`),
  KEY `FK_ec_kit_audit_trail_kit_id` (`kit_id`),
  CONSTRAINT `FK_ec_kit_audit_trail_kit_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1043 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_kit_lab_rejection_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_kit_lab_rejection_map` (
  `kit_id` bigint(20) NOT NULL,
  `lab_rejection_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`kit_id`,`lab_rejection_id`),
  KEY `IDX_ec_kit_lab_rejection_map_kit_id` (`kit_id`),
  KEY `FK_ec_kit_lab_rejection_map_lab_rejection_id` (`lab_rejection_id`),
  CONSTRAINT `FK_ec_kit_lab_rejection_map_kid_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_kit_lab_rejection_map_lab_rejection_id` FOREIGN KEY (`lab_rejection_id`) REFERENCES `ec_lab_rejections` (`lab_rejection_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_kit_partner_error_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_kit_partner_error_map` (
  `kit_id` bigint(20) NOT NULL,
  `partner_error_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`kit_id`,`partner_error_id`),
  KEY `IDX_ec_kit_partner_error_map_kit_id` (`kit_id`),
  CONSTRAINT `FK_ec_kit_partner_error_map_kid_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_kit_t_report_analytics_items_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_kit_t_report_analytics_items_map` (
  `kit_id` bigint(20) NOT NULL,
  `t_report_analytics_item_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`kit_id`,`t_report_analytics_item_id`),
  KEY `IDX_ec_kit_t_report_analytics_items_map_kit_id` (`kit_id`),
  CONSTRAINT `FK_ec_kit_t_report_analytics_items_map_kit_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_kits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_kits` (
  `kit_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_kit_id` bigint(20) NOT NULL,
  `requisition_id` bigint(20) DEFAULT NULL,
  `partner_id` bigint(20) DEFAULT NULL,
  `barcode` varchar(20) NOT NULL,
  `inbound_tracking_id` varchar(100) DEFAULT NULL,
  `inbound_shipping_label` mediumblob,
  `outbound_tracking_id` varchar(100) DEFAULT NULL,
  `outbound_shipping_label` mediumblob,
  `paid` tinyint(4) DEFAULT '0',
  `status` varchar(45) DEFAULT NULL,
  `read_status` varchar(45) DEFAULT 'UNREAD',
  `flagged_status` varchar(45) DEFAULT 'NONE',
  `release_status` varchar(45) DEFAULT 'HOLD',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`kit_id`),
  KEY `t_kit_id` (`t_kit_id`),
  KEY `FK_ec_kits_requisition_id` (`requisition_id`),
  KEY `FK_ec_kits_partner_id` (`partner_id`),
  CONSTRAINT `FK_ec_kits_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_kits_requisition_id` FOREIGN KEY (`requisition_id`) REFERENCES `ec_requisitions` (`requisition_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_kits_t_kit_id` FOREIGN KEY (`t_kit_id`) REFERENCES `ec_t_kits` (`t_kit_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1031 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=41902;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_lab_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_lab_data` (
  `lab_data_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lab_id` bigint(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `file_type` varchar(5) DEFAULT NULL,
  `data` blob,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`lab_data_id`),
  KEY `ec_lab_data_labs_fk_idx` (`lab_id`),
  CONSTRAINT `ec_lab_data_labs_fk` FOREIGN KEY (`lab_id`) REFERENCES `ec_labs` (`lab_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_lab_rejection_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_lab_rejection_responses` (
  `lab_rejection_response_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lab_rejection_id` bigint(20) NOT NULL,
  `response_text` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`lab_rejection_response_id`),
  KEY `IDX_ec_lab_rejection_responses_lab_rejection_id` (`lab_rejection_id`),
  CONSTRAINT `FK_ec_lab_rejections_responses_lab_rejection_id` FOREIGN KEY (`lab_rejection_id`) REFERENCES `ec_lab_rejections` (`lab_rejection_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_lab_rejections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_lab_rejections` (
  `lab_rejection_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lab_id` bigint(20) NOT NULL,
  `rejection_text` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`lab_rejection_id`),
  KEY `FK_ec_lab_rejections_lab_id` (`lab_id`),
  CONSTRAINT `FK_ec_lab_rejections_lab_id` FOREIGN KEY (`lab_id`) REFERENCES `ec_labs` (`lab_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_labs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_labs` (
  `lab_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `receiving_facility` varchar(45) DEFAULT NULL,
  `receiving_application` varchar(45) DEFAULT NULL,
  `shipping_name` varchar(45) DEFAULT NULL,
  `shipping_street1` varchar(45) DEFAULT NULL,
  `shipping_street2` varchar(45) DEFAULT NULL,
  `shipping_city` varchar(45) DEFAULT NULL,
  `shipping_state` varchar(45) DEFAULT NULL,
  `shipping_zip` varchar(45) DEFAULT NULL,
  `shipping_phone` varchar(45) DEFAULT NULL,
  `shipping_email` varchar(45) DEFAULT NULL,
  `manifest_password` varchar(40) DEFAULT NULL,
  `manifest_emails` varchar(255) DEFAULT NULL,
  `barcode_type` varchar(20) DEFAULT NULL,
  `report_street1` varchar(45) DEFAULT NULL,
  `report_street2` varchar(45) DEFAULT NULL,
  `report_city` varchar(45) DEFAULT NULL,
  `report_state` varchar(2) DEFAULT NULL,
  `report_zip` varchar(10) DEFAULT NULL,
  `report_phone` varchar(12) DEFAULT NULL,
  `report_fax` varchar(12) DEFAULT NULL,
  `logo_filename` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`lab_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_list_items` (
  `list_item_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `list_id` int(11) NOT NULL,
  `item` varchar(45) DEFAULT NULL,
  `description` varchar(45) NOT NULL,
  `sequence` mediumint(9) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`list_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_lists` (
  `list_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`list_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_messages` (
  `message_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `session` varchar(255) DEFAULT NULL,
  `level` varchar(10) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `message` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4357 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_panel_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_panel_products` (
  `panel_product_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_panel_product_id` bigint(20) DEFAULT NULL,
  `partner_id` bigint(20) DEFAULT NULL,
  `sort_order` int(3) DEFAULT NULL,
  `group` varchar(50) DEFAULT NULL,
  `sub_group` varchar(50) DEFAULT NULL,
  `retail` decimal(6,2) DEFAULT NULL,
  `price` decimal(6,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`panel_product_id`),
  KEY `FK_ec_panel_products_partner_id` (`partner_id`),
  KEY `FK_ec_panel_products_panel_product_id` (`t_panel_product_id`),
  CONSTRAINT `FK_ec_panel_products_panel_product_id` FOREIGN KEY (`t_panel_product_id`) REFERENCES `ec_t_panel_products` (`t_panel_product_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_panel_products_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_panels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_panels` (
  `panel_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_panel_id` bigint(20) DEFAULT NULL,
  `kit_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`panel_id`),
  KEY `FK_ec_panels_t_panel_id` (`t_panel_id`),
  KEY `FK_ec_panels_kit_id` (`kit_id`),
  CONSTRAINT `FK_ec_panels_kit_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ec_panels_t_panel_id` FOREIGN KEY (`t_panel_id`) REFERENCES `ec_t_panels` (`t_panel_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=862 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=204;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_partner_errors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_partner_errors` (
  `partner_error_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `error_type` varchar(255) NOT NULL,
  `error_response` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`partner_error_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_partner_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_partner_invoices` (
  `partner_invoice_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `invoice` blob,
  `sent_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`partner_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_partner_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_partner_order_detail` (
  `partner_order_detail_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `partner_order_id` bigint(20) DEFAULT NULL,
  `order_type` varchar(255) DEFAULT NULL,
  `order_type_id` varchar(255) DEFAULT NULL,
  `price` decimal(19,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_on` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`partner_order_detail_id`),
  KEY `FK_ec_partner_order_detail_partner_order_id` (`partner_order_id`),
  CONSTRAINT `FK_ec_partner_order_detail_partner_order_id` FOREIGN KEY (`partner_order_id`) REFERENCES `ec_partner_orders` (`partner_order_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_partner_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_partner_orders` (
  `partner_order_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `partner_id` bigint(20) DEFAULT NULL,
  `partner_invoice_id` bigint(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`partner_order_id`),
  KEY `FK_ec_partner_order_partner_id` (`partner_id`),
  KEY `FK_ec_partner_order_partner_invoice_id` (`partner_invoice_id`),
  CONSTRAINT `FK_ec_partner_order_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_partner_order_partner_invoice_id` FOREIGN KEY (`partner_invoice_id`) REFERENCES `ec_partner_invoices` (`partner_invoice_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_partner_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_partner_settings` (
  `partner_setting_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `partner_id` bigint(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `setting` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_on` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`partner_setting_id`),
  KEY `FK_ec_partner_settings_partner_id` (`partner_id`),
  CONSTRAINT `FK_ec_partner_settings_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_partners` (
  `partner_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `type_of` varchar(20) DEFAULT NULL,
  `demo` tinyint(4) DEFAULT NULL,
  `passport_product_id` bigint(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_policy_manager_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_policy_manager_terms` (
  `policy_manager_term_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `rule` varchar(45) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `terms` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`policy_manager_term_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_policy_manager_user_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_policy_manager_user_terms` (
  `policy_manager_user_term_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `policy_manager_term_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`policy_manager_user_term_id`),
  KEY `policy_manager_user_terms_terms_fk_idx` (`policy_manager_term_id`),
  KEY `policy_manager_user_terms_users_fk_idx` (`user_id`),
  CONSTRAINT `policy_manager_user_terms_terms_fk` FOREIGN KEY (`policy_manager_term_id`) REFERENCES `ec_policy_manager_terms` (`policy_manager_term_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `policy_manager_user_terms_users_fk` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=354 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_pwn_physicians`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_pwn_physicians` (
  `pwn_physician_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `license` varchar(45) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `npi` int(10) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`pwn_physician_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_pwn_physicians_reqs_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_pwn_physicians_reqs_map` (
  `requisition_id` int(11) DEFAULT NULL,
  `pwn_physician_id` int(11) DEFAULT NULL,
  KEY `phys_req_map_idx1` (`requisition_id`,`pwn_physician_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_questions` (
  `question_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_question_id` bigint(20) NOT NULL,
  `kit_id` bigint(20) NOT NULL,
  `group` varchar(255) DEFAULT NULL,
  `sub_group` varchar(255) DEFAULT NULL,
  `question` varchar(255) NOT NULL,
  `response` varchar(255) DEFAULT NULL,
  `required` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `locked` tinyint(1) DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `data_type_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`question_id`),
  KEY `index_ec_questions_on_kit_id` (`kit_id`),
  KEY `index_ec_questions_on_data_type_id` (`data_type_id`),
  KEY `FK_ec_questions_t_question_id` (`t_question_id`),
  CONSTRAINT `FK_ec_questions_kit_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ec_questions_t_question_id` FOREIGN KEY (`t_question_id`) REFERENCES `ec_t_questions` (`t_question_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=40925 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_ref_range_json`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_ref_range_json` (
  `ref_range_json_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `analyte` varchar(45) NOT NULL,
  `lab_id` bigint(20) DEFAULT NULL,
  `json` json DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`ref_range_json_id`),
  KEY `idx_ec_ref_range_json_analyte_lab_id` (`analyte`,`lab_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_ref_ranges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_ref_ranges` (
  `ref_range_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `analyte` varchar(45) NOT NULL,
  `lab_id` bigint(20) DEFAULT NULL,
  `xseq` int(3) DEFAULT NULL,
  `rr_avg` decimal(10,3) DEFAULT NULL,
  `rr_min` decimal(10,3) DEFAULT NULL,
  `rr_max` decimal(10,3) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`ref_range_id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_report_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_report_analytics` (
  `report_analytic_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_report_analytic_id` bigint(20) NOT NULL,
  `kit_id` bigint(20) DEFAULT NULL,
  `seq` int(3) DEFAULT NULL,
  `summary` varchar(45) DEFAULT NULL,
  `item_text` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_analytic_id`),
  KEY `report_analytics_kits_fk_idx` (`kit_id`),
  KEY `report_analytics_t_report_analytics_fk_idx` (`t_report_analytic_id`),
  CONSTRAINT `report_analytics_kits_fk` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE CASCADE,
  CONSTRAINT `report_analytics_t_report_analytics_fk` FOREIGN KEY (`t_report_analytic_id`) REFERENCES `ec_t_report_analytics` (`t_report_analytic_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1243 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_requisition_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_requisition_events` (
  `requisition_event_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `requisition_id` int(11) NOT NULL,
  `event_type` varchar(45) DEFAULT NULL,
  `event_desc` varchar(255) DEFAULT NULL,
  `event_summary` varchar(45) DEFAULT NULL,
  `tracking_type` varchar(8) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`requisition_event_id`),
  KEY `index_ec_requisition_events_on_requisition_id` (`requisition_id`)
) ENGINE=InnoDB AUTO_INCREMENT=908 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_requisition_manifests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_requisition_manifests` (
  `requisition_manifest_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `requisition_id` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`requisition_manifest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Requisition ids for labs that required a manifest.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_requisitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_requisitions` (
  `requisition_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `clinic_physician_id` bigint(20) DEFAULT NULL,
  `telemedicine_physician_id` bigint(20) DEFAULT NULL,
  `submission_id` varchar(20) DEFAULT NULL,
  `some_data` blob,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`requisition_id`),
  KEY `index_ec_requisitions_on_user_id` (`user_id`),
  KEY `FK_ec_requisitions_clinic_physician_id` (`clinic_physician_id`),
  KEY `index_ec_requisitions_on_telemedicine_physician_id` (`telemedicine_physician_id`),
  CONSTRAINT `FK_ec_requisitions_clinic_physician_id` FOREIGN KEY (`clinic_physician_id`) REFERENCES `ec_clinic_physicians` (`clinic_physician_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_requisitions_user_id` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=433 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_health_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_health_modules` (
  `t_health_module_id` bigint(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_health_module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_health_modules_t_kits_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_health_modules_t_kits_map` (
  `t_health_module_id` bigint(20) NOT NULL,
  `t_kit_id` bigint(20) NOT NULL,
  PRIMARY KEY (`t_health_module_id`,`t_kit_id`),
  KEY `IDX_ec_t_health_modules_t_kits_map_t_kit_id` (`t_kit_id`),
  CONSTRAINT `FK_ec_t_health_modules_t_kits_map_t_health_module_id` FOREIGN KEY (`t_health_module_id`) REFERENCES `ec_t_health_modules` (`t_health_module_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_t_health_modules_t_kits_map_t_kit_id` FOREIGN KEY (`t_kit_id`) REFERENCES `ec_t_kits` (`t_kit_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_health_modules_t_questions_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_health_modules_t_questions_map` (
  `t_health_module_id` bigint(20) NOT NULL,
  `t_question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`t_health_module_id`,`t_question_id`),
  KEY `IDX_ec_t_health_modules_t_questions_map_t_question_id` (`t_question_id`),
  CONSTRAINT `FK_ec_t_health_modules_t_questions_map_t_health_module_id` FOREIGN KEY (`t_health_module_id`) REFERENCES `ec_t_health_modules` (`t_health_module_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_t_health_modules_t_questions_map_t_question_id` FOREIGN KEY (`t_question_id`) REFERENCES `ec_t_questions` (`t_question_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_kit_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_kit_contents` (
  `t_kit_content_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_kit_content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_kits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_kits` (
  `t_kit_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lab_id` bigint(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `add_panels` tinyint(4) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `sample_instructions` varchar(45) DEFAULT NULL,
  `shipping_instructions` varchar(45) DEFAULT NULL,
  `approval_path` varchar(3) DEFAULT NULL,
  `barcode_length` int(11) DEFAULT '5',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_kit_id`),
  KEY `FK_ec_t_kits_lab_id` (`lab_id`),
  CONSTRAINT `FK_ec_t_kits_lab_id` FOREIGN KEY (`lab_id`) REFERENCES `ec_labs` (`lab_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_kits_t_kit_contents_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_kits_t_kit_contents_map` (
  `t_kit_id` bigint(20) NOT NULL,
  `t_kit_content_id` bigint(20) NOT NULL,
  PRIMARY KEY (`t_kit_id`,`t_kit_content_id`),
  KEY `IDX_ec_t_kits_t_kit_contents_map_t_kit_content_id` (`t_kit_content_id`),
  CONSTRAINT `FK_ec_t_kits_t_kit_contents_map_t_kit_content_id` FOREIGN KEY (`t_kit_content_id`) REFERENCES `ec_t_kit_contents` (`t_kit_content_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_t_kits_t_kit_contents_map_t_kit_id` FOREIGN KEY (`t_kit_id`) REFERENCES `ec_t_kits` (`t_kit_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_kits_t_panels_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_kits_t_panels_map` (
  `t_kit_id` bigint(20) NOT NULL,
  `t_panel_id` bigint(20) NOT NULL,
  PRIMARY KEY (`t_kit_id`,`t_panel_id`),
  KEY `IDX_ec_t_kits_t_panels_map_t_panel_id` (`t_panel_id`),
  CONSTRAINT `FK_ec_t_kits_t_panels_map_t_kit_id` FOREIGN KEY (`t_kit_id`) REFERENCES `ec_t_kits` (`t_kit_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_t_kits_t_panels_map_t_panel_id` FOREIGN KEY (`t_panel_id`) REFERENCES `ec_t_panels` (`t_panel_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_panel_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_panel_products` (
  `t_panel_product_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_panel_id` bigint(20) DEFAULT NULL,
  `cost` decimal(6,2) DEFAULT NULL,
  `retail` decimal(6,2) DEFAULT NULL,
  `price` decimal(6,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_panel_product_id`),
  KEY `FK_ec_t_panel_products_t_panel_id` (`t_panel_id`),
  CONSTRAINT `FK_ec_t_panel_products_t_panel_id` FOREIGN KEY (`t_panel_id`) REFERENCES `ec_t_panels` (`t_panel_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_panel_t_report_analytic_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_panel_t_report_analytic_map` (
  `t_panel_id` bigint(20) NOT NULL,
  `t_report_analytic_id` bigint(20) NOT NULL,
  PRIMARY KEY (`t_panel_id`,`t_report_analytic_id`),
  KEY `IDX_ec_t_panels_t_report_analytic_map_t_panel_id` (`t_panel_id`),
  KEY `FK_ec_t_panel_t_report_analytic_map_report_analytic_id` (`t_report_analytic_id`),
  CONSTRAINT `FK_ec_t_panel_t_report_analytic_map_panel_id` FOREIGN KEY (`t_panel_id`) REFERENCES `ec_t_panels` (`t_panel_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_t_panel_t_report_analytic_map_report_analytic_id` FOREIGN KEY (`t_report_analytic_id`) REFERENCES `ec_t_report_analytics` (`t_report_analytic_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_panels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_panels` (
  `t_panel_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lab_id` bigint(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `group` varchar(50) DEFAULT NULL,
  `sub_group` varchar(50) DEFAULT NULL,
  `matrix` varchar(25) DEFAULT NULL,
  `pwn_order_code` varchar(45) DEFAULT NULL,
  `lab_order_code` varchar(45) DEFAULT NULL,
  `sample_instructions` text,
  `shipping_instructions` text,
  `about` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_panel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_panels_t_questions_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_panels_t_questions_map` (
  `t_panel_id` bigint(20) NOT NULL,
  `t_question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`t_panel_id`,`t_question_id`),
  KEY `IDX_ec_t_panels_t_questions_map_t_question_id` (`t_question_id`),
  CONSTRAINT `FK_ec_t_panels_t_questions_map_t_panel_id` FOREIGN KEY (`t_panel_id`) REFERENCES `ec_t_panels` (`t_panel_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_t_panels_t_questions_map_t_question_id` FOREIGN KEY (`t_question_id`) REFERENCES `ec_t_questions` (`t_question_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_panels_t_tests_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_panels_t_tests_map` (
  `t_panel_id` bigint(20) NOT NULL,
  `t_test_id` bigint(20) NOT NULL,
  `sequence` int(3) DEFAULT NULL,
  PRIMARY KEY (`t_panel_id`,`t_test_id`),
  KEY `IDX_ec_t_panels_t_tests_map_t_test_id` (`t_test_id`),
  CONSTRAINT `FK_ec_t_panels_t_tests_map_t_panel_id` FOREIGN KEY (`t_panel_id`) REFERENCES `ec_t_panels` (`t_panel_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_t_panels_t_tests_map_t_test_id` FOREIGN KEY (`t_test_id`) REFERENCES `ec_t_tests` (`t_test_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_questions` (
  `t_question_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group` varchar(50) DEFAULT NULL,
  `sub_group` varchar(50) DEFAULT NULL,
  `question` varchar(255) NOT NULL,
  `required` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `data_type_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_question_id`),
  KEY `index_ec_t_questions_on_data_type_id` (`data_type_id`),
  CONSTRAINT `FK_ec_t_questions_data_type_id` FOREIGN KEY (`data_type_id`) REFERENCES `ec_data_types` (`data_type_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_report_analytic_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_report_analytic_features` (
  `t_report_analytic_item_id` bigint(20) NOT NULL,
  `model_number` int(11) NOT NULL,
  `seq` int(11) NOT NULL,
  `multiplier` decimal(4,2) NOT NULL,
  PRIMARY KEY (`t_report_analytic_item_id`,`seq`,`model_number`),
  KEY `IDX_ec_t_report_analytic_features_t_report_analytic_item_id` (`t_report_analytic_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_report_analytic_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_report_analytic_items` (
  `t_report_analytic_item_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_report_analytic_id` bigint(20) NOT NULL,
  `seq` int(11) NOT NULL,
  `summary` varchar(45) DEFAULT NULL,
  `item_text` text NOT NULL,
  `partner_type_of` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`t_report_analytic_item_id`),
  KEY `IDX_ec_t_report_analytic_items_t_report_analytic_id` (`t_report_analytic_id`),
  CONSTRAINT `FK_ec_t_report_analytic_items_t_report_analytic_id` FOREIGN KEY (`t_report_analytic_id`) REFERENCES `ec_t_report_analytics` (`t_report_analytic_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_report_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_report_analytics` (
  `t_report_analytic_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_type` varchar(45) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`t_report_analytic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_t_tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_t_tests` (
  `t_test_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `test` varchar(50) DEFAULT NULL,
  `sequence` int(2) DEFAULT NULL,
  `data_type_id` bigint(20) DEFAULT NULL,
  `units` varchar(50) DEFAULT NULL,
  `ref_range` varchar(50) DEFAULT NULL,
  `test_code` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_test_id`),
  KEY `index_ec_t_tests_on_data_type_id` (`data_type_id`),
  CONSTRAINT `FK_ec_t_tests_data_type_id` FOREIGN KEY (`data_type_id`) REFERENCES `ec_data_types` (`data_type_id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_tests` (
  `test_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_test_id` bigint(20) NOT NULL,
  `kit_id` bigint(20) DEFAULT NULL,
  `panel_id` bigint(20) DEFAULT NULL,
  `test_name` varchar(45) NOT NULL,
  `sequence` int(3) DEFAULT NULL,
  `sort_order` int(3) DEFAULT NULL,
  `collected_at` datetime DEFAULT NULL,
  `result` varchar(45) DEFAULT NULL,
  `data_type_id` bigint(20) DEFAULT NULL,
  `units` varchar(45) DEFAULT NULL,
  `ref_range` varchar(45) DEFAULT NULL,
  `rr_min` decimal(10,3) DEFAULT NULL,
  `rr_max` decimal(10,3) DEFAULT NULL,
  `rr_avg` decimal(10,3) DEFAULT NULL,
  `rr_stdev` decimal(10,3) DEFAULT NULL,
  `z_score` decimal(6,3) DEFAULT NULL,
  `matrix` varchar(45) DEFAULT NULL,
  `abnormal_flags` varchar(45) DEFAULT NULL,
  `result_status` varchar(45) DEFAULT NULL,
  `result_date` date DEFAULT NULL,
  `test_code` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`test_id`),
  KEY `index_ec_tests_on_data_type_id` (`data_type_id`),
  KEY `index_ec_tests_on_kit_id` (`kit_id`),
  KEY `FK_ec_tests_panel_id` (`panel_id`),
  CONSTRAINT `FK_ec_tests_data_type_id` FOREIGN KEY (`data_type_id`) REFERENCES `ec_data_types` (`data_type_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_tests_kit_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ec_tests_panel_id` FOREIGN KEY (`panel_id`) REFERENCES `ec_panels` (`panel_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2184 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=780;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_tests_extra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_tests_extra` (
  `test_extra_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `t_test_id` bigint(20) DEFAULT NULL,
  `kit_id` bigint(20) DEFAULT NULL,
  `panel_id` bigint(20) DEFAULT NULL,
  `test_name` varchar(45) NOT NULL,
  `sequence` int(3) DEFAULT NULL,
  `sort_order` int(3) DEFAULT NULL,
  `collected_at` datetime DEFAULT NULL,
  `result` varchar(45) DEFAULT NULL,
  `data_type_id` bigint(20) DEFAULT NULL,
  `units` varchar(45) DEFAULT NULL,
  `ref_range` varchar(45) DEFAULT NULL,
  `rr_min` decimal(10,3) DEFAULT NULL,
  `rr_max` decimal(10,3) DEFAULT NULL,
  `rr_avg` decimal(10,3) DEFAULT NULL,
  `rr_stdev` decimal(10,3) DEFAULT NULL,
  `z_score` decimal(6,3) DEFAULT NULL,
  `matrix` varchar(45) DEFAULT NULL,
  `abnormal_flags` varchar(45) DEFAULT NULL,
  `result_status` varchar(45) DEFAULT NULL,
  `result_date` date DEFAULT NULL,
  `test_code` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`test_extra_id`),
  KEY `index_ec_tests_extra_on_data_type_id` (`data_type_id`),
  KEY `index_ec_tests_extra_on_kit_id` (`kit_id`),
  KEY `FK_ec_tests_extra_panel_id` (`panel_id`),
  CONSTRAINT `FK_ec_tests_extra_data_type_id` FOREIGN KEY (`data_type_id`) REFERENCES `ec_data_types` (`data_type_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_tests_extra_kit_id` FOREIGN KEY (`kit_id`) REFERENCES `ec_kits` (`kit_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ec_tests_extra_panel_id` FOREIGN KEY (`panel_id`) REFERENCES `ec_panels` (`panel_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_user_demographics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_user_demographics` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `birthdate` date DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `last_period_first_day` date DEFAULT NULL,
  `postmenopausal` varchar(1) DEFAULT NULL,
  `race` varchar(20) DEFAULT NULL,
  `height_in` mediumint(9) DEFAULT NULL,
  `weight_lbs` mediumint(9) DEFAULT NULL,
  `waist_circ_in` smallint(6) DEFAULT NULL,
  `hip_circ_in` smallint(6) DEFAULT NULL,
  `bmi` decimal(4,1) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `FK_ec_user_demographics_user_id` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=610 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_user_meds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_user_meds` (
  `user_med_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `dosage` decimal(10,0) DEFAULT NULL,
  `dosage_units` varchar(10) DEFAULT NULL,
  `is_contraceptive` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_med_id`),
  KEY `FK_ec_user_meds_user_id` (`user_id`),
  CONSTRAINT `FK_ec_user_meds_user_id` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_user_message_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_user_message_attachments` (
  `user_message_attachment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_message_id` bigint(20) DEFAULT NULL,
  `attachment` blob,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_on` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_message_attachment_id`),
  KEY `FK_ec_user_message_attachments_ec_user_messages_user_message_id` (`user_message_id`),
  CONSTRAINT `FK_ec_user_message_attachments_ec_user_messages_user_message_id` FOREIGN KEY (`user_message_id`) REFERENCES `ec_user_messages` (`user_message_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_user_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_user_messages` (
  `user_message_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `type_of` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `body` text,
  `delivered` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_on` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_message_id`),
  KEY `FK_ec_user_messages_ec_users_user_id` (`user_id`),
  CONSTRAINT `FK_ec_user_messages_ec_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=455 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_user_settings` (
  `user_setting_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `setting` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_setting_id`),
  KEY `FK_ec_user_settings_ec_users_user_id` (`user_id`),
  CONSTRAINT `FK_ec_user_settings_ec_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime(6) DEFAULT NULL,
  `remember_created_at` datetime(6) DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `stripe_id` varchar(255) DEFAULT NULL,
  `ship_address_id` int(11) DEFAULT NULL,
  `bill_address_id` int(11) DEFAULT NULL,
  `global_admin` tinyint(1) DEFAULT NULL,
  `partner_admin` tinyint(1) DEFAULT NULL,
  `coach_admin` tinyint(4) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `index_ec_users_on_confirmation_token` (`confirmation_token`),
  KEY `index_ec_users_on_email` (`email`),
  KEY `index_ec_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=611 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ec_users_partners_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ec_users_partners_map` (
  `user_id` bigint(20) NOT NULL,
  `partner_id` bigint(20) NOT NULL,
  `partner_user_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`partner_id`),
  KEY `IDX_ec_users_partners_map_partner_id` (`partner_id`),
  CONSTRAINT `FK_ec_users_partners_map_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`) ON DELETE NO ACTION,
  CONSTRAINT `FK_ec_users_partners_map_user_id` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=468;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `friendly_id_slugs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friendly_id_slugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) NOT NULL,
  `sluggable_id` int(11) NOT NULL,
  `sluggable_type` varchar(50) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope` (`slug`,`sluggable_type`,`scope`),
  KEY `index_friendly_id_slugs_on_slug_and_sluggable_type` (`slug`,`sluggable_type`),
  KEY `index_friendly_id_slugs_on_sluggable_id` (`sluggable_id`),
  KEY `index_friendly_id_slugs_on_sluggable_type` (`sluggable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `health_care_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `health_care_providers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `telemedicine_physician_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_health_care_providers_on_email` (`email`),
  UNIQUE KEY `index_health_care_providers_on_telemedicine_physician_id` (`telemedicine_physician_id`),
  UNIQUE KEY `index_health_care_providers_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `health_modules_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `health_modules_accounts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `encrypted_password` varchar(255) DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_health_modules_accounts_on_email` (`email`),
  KEY `index_health_modules_accounts_on_remember_token` (`remember_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `identities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `consented_at` datetime NOT NULL,
  `id_type` varchar(20) DEFAULT NULL,
  `id_front_s3_key` varchar(255) DEFAULT NULL,
  `id_back_s3_key` varchar(255) DEFAULT NULL,
  `selfie_s3_key` varchar(255) DEFAULT NULL,
  `identity_verified` tinyint(4) DEFAULT NULL,
  `idemia_id` varchar(64) DEFAULT NULL,
  `idemia_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_identities_on_account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `partner_access_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partner_access_codes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `partner_id` bigint(20) NOT NULL,
  `access_code` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_partner_access_codes_on_access_code` (`access_code`),
  KEY `index_partner_access_codes_on_partner_id` (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `passport_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passport_products` (
  `passport_product_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `t_kit_id` bigint(20) DEFAULT NULL,
  `daily_survey` tinyint(4) DEFAULT '0',
  `identity_and_results` tinyint(4) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`passport_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_attributes` (
  `attribute_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `attribute` varchar(80) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`attribute_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_clinical_lab_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_clinical_lab_results` (
  `clinical_lab_result_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `clinical_lab_id` bigint(20) NOT NULL,
  `result_date` datetime DEFAULT NULL,
  `test_name` varchar(45) NOT NULL,
  `attribute_id` bigint(20) DEFAULT NULL COMMENT 'Hale will assign tests to attributes',
  `result` decimal(10,2) NOT NULL COMMENT 'Other partners may have qualitative test results, high quality problem',
  `lower_range` decimal(10,2) DEFAULT NULL,
  `upper_range` decimal(10,2) DEFAULT NULL,
  `sequence` int(3) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`clinical_lab_result_id`),
  KEY `ptnr_clinical_lab_res_FK_1` (`clinical_lab_id`),
  KEY `ptnr_clinical_lab_res_FK_2` (`attribute_id`),
  CONSTRAINT `ptnr_clinical_lab_res_FK_1` FOREIGN KEY (`clinical_lab_id`) REFERENCES `ptnr_clinical_labs` (`clinical_lab_id`),
  CONSTRAINT `ptnr_clinical_lab_res_FK_2` FOREIGN KEY (`attribute_id`) REFERENCES `ptnr_attributes` (`attribute_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6206 DEFAULT CHARSET=utf8 COMMENT='pdf_file goes into ec_attachments';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_clinical_labs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_clinical_labs` (
  `clinical_lab_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `partner_id` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`clinical_lab_id`),
  KEY `ptnr_clinical_lab_FI_1` (`user_id`),
  KEY `ptnr_clinical_lab_FI_2` (`partner_id`),
  CONSTRAINT `ptnr_clinical_lab_FK_1` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`),
  CONSTRAINT `ptnr_clinical_lab_FK_2` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='pdf_file goes into ec_attachments';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_clinicallabdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_clinicallabdata` (
  `clinicallabdata_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `partner_id` bigint(20) NOT NULL,
  `clinicallab_json` json NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`clinicallabdata_id`),
  KEY `ptnr_clinicallabdata_FI_1` (`user_id`),
  KEY `ptnr_clinicallabdata_FI_2` (`partner_id`),
  CONSTRAINT `ptnr_clinicallabdata_FI_2` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`),
  CONSTRAINT `ptnr_clinicallabdata_FK_1` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_forceplatedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_forceplatedata` (
  `forceplatedata_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `partner_id` bigint(20) NOT NULL,
  `forceplate_json` json NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`forceplatedata_id`),
  KEY `ptnr_forceplatedata_FI_1` (`user_id`),
  KEY `ptnr_forceplatedata_FI_2` (`partner_id`),
  CONSTRAINT `ptnr_forceplatedata_FK_1` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`),
  CONSTRAINT `ptnr_forceplatedata_FK_2` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_genedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_genedata` (
  `genedata_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `partner_id` bigint(20) NOT NULL,
  `genedata_json` json NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`genedata_id`),
  KEY `ptnr_genedata_FI_1` (`user_id`),
  KEY `ptnr_genedata_FI_2` (`partner_id`),
  CONSTRAINT `ptnr_genedata_FK_1` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`),
  CONSTRAINT `ptnr_genedata_FK_2` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_medhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_medhistory` (
  `medhistory_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `partner_id` bigint(20) NOT NULL,
  `medhistory_json` json NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`medhistory_id`),
  KEY `ptnr_medhistory_FI_1` (`user_id`),
  KEY `ptnr_medhistory_FI_2` (`partner_id`),
  CONSTRAINT `ptnr_medhistory_FK_1` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`),
  CONSTRAINT `ptnr_medhistory_FK_2` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ptnr_microbiomedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptnr_microbiomedata` (
  `microbiomedata_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `partner_id` bigint(20) NOT NULL,
  `microbiome_json` json NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`microbiomedata_id`),
  KEY `ptnr_microbiomedata_FI_1` (`user_id`),
  KEY `ptnr_microbiomedata_FI_2` (`partner_id`),
  CONSTRAINT `ptnr_microbiomedata_FK_1` FOREIGN KEY (`user_id`) REFERENCES `ec_users` (`user_id`),
  CONSTRAINT `ptnr_microbiomedata_FK_2` FOREIGN KEY (`partner_id`) REFERENCES `ec_partners` (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `spree_store_credit_update_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_store_credit_update_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `surveys` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `fever_above_range` varchar(255) DEFAULT NULL,
  `feverish` varchar(255) DEFAULT NULL,
  `chills` varchar(255) DEFAULT NULL,
  `myalgia` varchar(255) DEFAULT NULL,
  `rhinorrhea` varchar(255) DEFAULT NULL,
  `sore_throat` varchar(255) DEFAULT NULL,
  `cough` varchar(255) DEFAULT NULL,
  `dyspnea` varchar(255) DEFAULT NULL,
  `nausea_or_vomiting` varchar(255) DEFAULT NULL,
  `headache` varchar(255) DEFAULT NULL,
  `abdominal_pain` varchar(255) DEFAULT NULL,
  `diarrea` varchar(255) DEFAULT NULL,
  `loss_of_taste` varchar(255) DEFAULT NULL,
  `loss_of_smell` varchar(255) DEFAULT NULL,
  `others` varchar(255) DEFAULT NULL,
  `sickness_start_date` datetime DEFAULT NULL,
  `sickness_end_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_surveys_on_account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `telemedicine_physician_licenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telemedicine_physician_licenses` (
  `telemedicine_physician_license_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `telemedicine_physician_id` bigint(20) NOT NULL,
  `license` varchar(45) NOT NULL,
  `state` char(2) NOT NULL,
  `expiration_date` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`telemedicine_physician_license_id`),
  KEY `telemedicine_physician_licenses_telemedicine_physicians_fk_idx` (`telemedicine_physician_id`),
  CONSTRAINT `telemedicine_physician_licenses_telemedicine_physicians_fk` FOREIGN KEY (`telemedicine_physician_id`) REFERENCES `telemedicine_physicians` (`telemedicine_physician_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `telemedicine_physicians`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telemedicine_physicians` (
  `telemedicine_physician_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `confirmation_code` varchar(255) DEFAULT NULL,
  `first_name` varchar(40) DEFAULT NULL,
  `middle_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(40) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `npi` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`telemedicine_physician_id`),
  UNIQUE KEY `index_telemedicine_physicians_on_confirmation_code` (`confirmation_code`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 DROP FUNCTION IF EXISTS `api_getMenstrualFirstDay` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `api_getMenstrualFirstDay`(in_kit_id bigint(20)) RETURNS varchar(255) CHARSET utf8
begin
  declare v_first_day varchar(255);
  
  select ifnull((select q.response from ec_questions q where q.kit_id = in_kit_id and q.group = 'Menstrual Status' and q.question like '%first day%'), null)
  into v_first_day;

  return v_first_day;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `api_getMenstrualStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `api_getMenstrualStatus`(in_kit_id bigint(20)) RETURNS varchar(255) CHARSET utf8
begin
  declare v_cycle varchar(255);
  
  select ifnull((select q.response from ec_questions q where  q.kit_id = in_kit_id and q.group = 'Menstrual Status' and q.question like '%cycle%'), null)
  into v_cycle;

  if (v_cycle like 'Regular%') or (v_cycle like 'Irregular%') or (v_cycle like 'Pre%') then
    set v_cycle = 'MENSES001';
  else
    set v_cycle = 'MENSES002';
  end if;

  return v_cycle;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `api_getPartnerIdFromName` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `api_getPartnerIdFromName`(in_partner_name varchar(255)) RETURNS bigint(20)
begin
  declare n_partner_id bigint(20);
  
  
  select partner_id into n_partner_id 
    from ec_partners p
   where p.name = in_partner_name;

  return n_partner_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `api_getUserIdFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `api_getUserIdFromPartner`( in_partner_user_id varchar(255), in_partner_id bigint(20) ) RETURNS bigint(20)
begin
  declare n_user_id bigint(20);
  
  select user_id into n_user_id 
    from ec_users_partners_map m
   where m.partner_user_id = in_partner_user_id
     and m.partner_id = in_partner_id;

  return n_user_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `api_requiresManifestCredentials` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `api_requiresManifestCredentials`(in_requisition_id int(11)) RETURNS int(1)
begin
	
    declare b_requires_manifest int(1) default 0;
    
    select case when l.manifest_password is null then 0
                when trim(l.manifest_password) = '' then 0
                else 1
			end into b_requires_manifest
           
	  from ec_requisitions r, ec_kits k, ec_t_kits tk, ec_labs l
	 where r.requisition_id = in_requisition_id
	   and k.requisition_id = r.requisition_id
	   and k.t_kit_id = tk.t_kit_id
	   and tk.lab_id = l.lab_id
	   and l.manifest_password is not null
	   and l.manifest_emails is not null;

    return b_requires_manifest;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `api_StdDev` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `api_StdDev`(x decimal(6,2), y decimal(6,2)) RETURNS decimal(10,4)
begin
  
  declare out_stddev decimal(10,4);
  
  select sqrt(pow((x - (x+y) / 2.0), 2) + pow((y - (x+y)/2.0), 2))
  into out_stddev;
  
  return out_stddev;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `api_TestSortOrder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `api_TestSortOrder`(n_kit_id bigint(20), n_t_test_id bigint(20)) RETURNS int(3)
BEGIN
  declare i int(3);

  select distinct ptm.sequence sort_order
    into i
    from ec_kits k,
         ec_panels p,
         ec_t_panels tp,
         ec_t_panels_t_tests_map ptm,
         ec_t_tests tt
   where k.kit_id = n_kit_id
     and p.kit_id = k.kit_id
     and tp.t_panel_id = p.t_panel_id
     and ptm.t_panel_id = tp.t_panel_id
     and tt.t_test_id = ptm.t_test_id   
     and tt.t_test_id = n_t_test_id
     and ptm.sequence is not null
   order
      by ptm.sequence;
    
    return i;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `debug` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `debug`(v_level VARCHAR(255), v_message TEXT) RETURNS int(11)
BEGIN
  insert
    into admin_debug
        (level,
         message)
  values(v_level,
         v_message);
RETURN 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_create_kit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_create_kit`(i_tkit_id int, i_partner_id int, v_ib_tracking_id varchar(255)) RETURNS bigint(20)
begin
  declare n_new_kit_id bigint;
  declare n_barcode_length int default 5;
  
  select barcode_length into n_barcode_length from ec_t_kits where t_kit_id = i_tkit_id;
  
  call ec_log_message('INFO', concat('ec_create_kit(', i_tkit_id, ', ', i_partner_id, ', ', v_ib_tracking_id, ')'), 'Creating Kit');

  insert 
    into ec_kits(
         t_kit_id,
         barcode, 
         partner_id,
         inbound_tracking_id,
         status)
  select i_tkit_id,
         ec_randombarcode(n_barcode_length),
         i_partner_id,
         v_ib_tracking_id,
         'LOGGED'
    from ec_t_kits
   where t_kit_id = i_tkit_id;
         
  select last_insert_id() 
    into n_new_kit_id;         

  return n_new_kit_id;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_create_module` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_create_module`(i_tmodule_id INT, i_user_id INT) RETURNS int(11)
BEGIN
  declare i_new_module_id int;

  call ec_log_message('INFO', concat('ec_create_module(', i_tmodule_id, ', ', i_user_id, ')'), 'Creating Module');

  insert
    into ec_health_modules
        (t_health_module_id,
         user_id)
  select t_health_module_id,
         i_user_id
    from ec_t_health_modules
   where t_health_module_id = i_tmodule_id;

  select last_insert_id()
    into i_new_module_id;

  return i_new_module_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_getDailyCheckupStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_getDailyCheckupStatus`(in_account_id bigint) RETURNS tinyint(4)
begin
  
  declare dt_latest_date date default null;
  declare n_answered_yes tinyint default 0;
  declare n_checkup_status tinyint default 0;
  declare n_kit_id bigint default null;
  
  declare n_question_count int default 0;
  declare n_question_null int default 0;
  declare n_question_temperature int default 0;
  declare n_question_yes int default 0;
  
  
  
  select k.kit_id
    into n_kit_id 
    from ec_kits k,
         ec_requisitions r,
         accounts a
   where k.requisition_id = r.requisition_id
	 and r.user_id = a.user_id
	 and a.id = in_account_id
   order 
      by k.kit_id desc
   limit 1;
  
  
  select max(date(updated_at))
    into dt_latest_date 
    from ec_questions
   where kit_id = n_kit_id;
  
  
  if (n_kit_id is not null && dt_latest_date = curdate()) then
	  select  count(q.response),
			  sum( case when q.response is null then 1 else 0 end),
			  sum( case when q.response = 'Yes' then 1 else 0 end),
			  sum( case when q.question = 'Temperature' then cast(coalesce(q.response,0) as decimal) else 0 end) 
		into  n_question_count, n_question_null, n_question_yes, n_question_temperature
	    from ec_questions q
	   where q.kit_id = n_kit_id
	     and data_type_id in (3,24) 
		 and date(q.updated_at) = dt_latest_date;     

	if (n_question_yes > 0 or n_question_temperature >= 100.4) then
	  set n_checkup_status = 2;
    elseif (n_question_null < n_question_count) then
      set n_checkup_status = 1;
	end if;

  end if;
  
  return n_checkup_status;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_get_baseline_test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_get_baseline_test`(i_hm_id bigint(20), v_test_name varchar(100)) RETURNS bigint(20)
BEGIN
  declare i_test_id bigint(20);
  
	select test_id 
      into i_test_id
	  from ec_tests t2 
	where t2.kit_id in(select kit_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
	  and t2.test_name = v_test_name
      and t2.result_date = (select min(result_date) from ec_tests where kit_id = t2.kit_id and test_name = t2.test_name);
      
      
RETURN i_test_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_randomBarcode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_randomBarcode`(length smallint(3)) RETURNS varchar(100) CHARSET utf8
begin
  set @returnStr = '';
  
  
  set @allowedChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; 
  set @i = 0;
  set @v_new_barcode = '';

	set @activeKitId = 1;
	while (@activeKitId is not null) do
    while (@i < length) do
        set @returnStr = concat(@returnStr, substring(@allowedChars, floor(rand() * length(@allowedChars) + 1), 1));
        set @i = @i + 1;
    end while;
          
    set @v_new_barcode = @returnStr;

	  set @activeKitId = (select kit_id
                          from ec_kits k
                         where k.barcode = @v_new_barcode
                           and(k.requisition_id is null 
                            or k.requisition_id in(select r.requisition_id 
                                                     from ec_requisitions r 
                                                    where k.requisition_id = r.requisition_id 
                                                      and r.submission_id is null)));
  end while;
  
  return @v_new_barcode;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_report_color` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_report_color`(z_score decimal) RETURNS varchar(25) CHARSET utf8
BEGIN
  declare v_color varchar(25);

    
    if z_score < 1 || z_score > 1 then
	  set v_color = 'red';
	elseif z_score < 0.9 || z_score > 0.9 then
	  set v_color = 'yellow';
    else
	  set v_color = 'green';
    end if;
    
	return v_color;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_summary_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_summary_data`(i_hm_id bigint(20), v_test_name varchar(255)) RETURNS text CHARSET utf8
BEGIN
  declare v_result_json text;
  declare i_max_results integer;
  
  select max(cnt) into i_max_results from 
  (select t.test_name,
          count(*) cnt
	 from ec_kits k,
		  ec_tests t
	where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = 2)
	  and t.kit_id = k.kit_id
     
	 group 
		by t.test_name) x;

	select 
		   
		   
		   case
			 when count(*) = 1 then
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 

			 when count(*) = 2 then
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
			  (select concat('{ "2": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 1,1), 
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 

			 when count(*) = 3 then
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
			  (select concat('{ "2": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 1,1), 
			  (select concat('{ "3": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 2,1),
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 

			 else         
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
			  (select concat('{ "2": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 1,1), 
			  (select concat('{ "3": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 2,1),
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 
		   end as result_json
	  into v_result_json
	  from ec_kits k,
		   ec_tests t
	 where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
	   and t.kit_id = k.kit_id
       and t.test_name = v_test_name
	 group 
		by t.test_name;
		
		
RETURN v_result_json;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ec_summary_data_all` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `ec_summary_data_all`(i_hm_id bigint(20)) RETURNS text CHARSET utf8
BEGIN
  declare v_result_json text;
  declare i_max_results integer;
  
  select max(cnt) into i_max_results from 
  (select t.test_name,
          count(*) cnt
	 from ec_kits k,
		  ec_tests t
	where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = 2)
	  and t.kit_id = k.kit_id
     
	 group 
		by t.test_name) x;

	select 
		   
		   
		   case
			 when count(*) = 1 then
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 

			 when count(*) = 2 then
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
			  (select concat('{ "2": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 1,1), 
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 

			 when count(*) = 3 then
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
			  (select concat('{ "2": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 1,1), 
			  (select concat('{ "3": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 2,1),
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 

			 else         
			   concat('{ "', t.test_name, '": ', 
			  (select concat('[{ "baseline": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') from ec_tests t2 where test_id = min(t.test_id)), 
			  (select concat('{ "2": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 1,1), 
			  (select concat('{ "3": ', '[{ ', '"value": "', result, '"},', '{ "color": "', ec_report_color(t2.z_score), '" },', '{ "link1": "/kits/', t2.kit_id, '_Show Kit Detail', '" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }]},') 
				 from ec_tests t2,
					  ec_kits k2
				where k2.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
				  and t2.kit_id = k2.kit_id
				  and t2.test_name = t.test_name order by test_id limit 2,1),
              '{ "baseline": ', '[{ ', '"value": ""},', '{ "color": "" },', '{ "link1": "" },', '{ "date": "', date_format(date_add(min(t.result_date), interval 3 month),"%c/%e/%Y"), '" }]},',
			  (select concat('{ "current": ', '[{ ', '"value": "', round((rr_min + rr_max)/2,2), '"},', '{ "color": "green" },', '{ "date": "', date_format(result_date,"%c/%e/%Y"), '" }] }] }') from ec_tests t2 where test_id = max(t.test_id))) 
		   end as result_json
	  into v_result_json
	  from ec_kits k,
		   ec_tests t
	 where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
	   and t.kit_id = k.kit_id
	 group 
		by t.test_name;
		
		
RETURN v_result_json;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `xx_create_kit_from_template` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `xx_create_kit_from_template`(i_t_kit_id bigint, i_partner_id bigint, v_inbound_tracking_id varchar(100)) RETURNS bigint(20)
begin

  declare n_finished int(1) default 0;
  declare n_new_kit_id bigint(20);
  declare n_t_kit_id bigint(20);
  declare v_new_barcode varchar(128);
  declare v_order_code varchar(45);
  declare v_question varchar(45);
  declare v_name varchar(45);
  declare v_sample_instructions varchar(45);
  declare v_shipping_instructions varchar(45);
  declare i integer;
    
  
  declare t_quest_cur cursor for
    select q.question
      from ec_t_questions q,
           ec_t_kits_t_questions_map m
     where m.t_kit_id = n_t_kit_id
       and q.t_question_id = m.t_question_id;
   
  
  declare continue handler for not found set n_finished = 1; 
  
  set i = 0;
    
  
  
  select name,
         sample_instructions, 
         shipping_instructions, 
         t_kit_id, 
         order_code 
    into v_name,
         v_sample_instructions, 
         v_shipping_instructions, 
         n_t_kit_id, 
         v_order_code
     from ec_t_kits 
    where t_kit_id = i_t_kit_id;
            
  
  
  
  
  set i = i + 1;
  set n_finished = 0;
	
	set @activeKitId = 1;
	while (@activeKitId is not null) do
	  set v_new_barcode = ec_randombarcode(5);
	  set @activeKitId = (select kit_id
                          from ec_kits k
                         where k.barcode = v_new_barcode
                           and(k.requisition_id is null 
                            or k.requisition_id in(select r.requisition_id 
                                                     from ec_requisitions r 
                                                    where k.requisition_id = r.requisition_id 
                                                      and r.submission_id is null)));
  end while;
    
  
  insert 
    into ec_kits(
         requisition_id,
         type_of, 
         barcode, 
         partner_id,
         order_code, 
         sample_instructions, 
         shipping_instructions, 
         inbound_tracking_id,
         status,
         created_at, 
         updated_at)
   values(null,
          v_name,
          v_new_barcode,
          i_partner_id,
          v_order_code, 
          v_sample_instructions,
          v_shipping_instructions,
          v_inbound_tracking_id,
          'LOGGED',
          now(),
          now());
		
  select last_insert_id() 
    into n_new_kit_id;
	
  
  open t_quest_cur;
    insert_questions: loop
    fetch t_quest_cur into v_question;
  
    if n_finished = 1 then
     leave insert_questions;
    end if;

		insert
		  into ec_questions(
           kit_id, 
           question, 
           response, 
           data_type_id, 
           created_at, 
           updated_at)
		values(n_new_kit_id,
           v_question,
           null,
           null,
           now(),
           now());

  end loop; 	
	close t_quest_cur;    
    
  return n_new_kit_id;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `xx_temp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `xx_temp`() RETURNS bigint(20)
begin
  declare n_kit_id bigint(20);
  declare n_t_test_id bigint(20);
  declare n_finished int;

  declare t_cur cursor for
    select t.kit_id,
           t.t_test_id
      from ec_tests t
     order 
        by t.test_id;
   
  declare continue handler for not found set n_finished = 1; 
  
  open t_cur;
    insert_questions: loop
    fetch t_cur into n_kit_id, n_t_test_id;
  
    if n_finished = 1 then
     leave insert_questions;
    end if;

		update ec_tests
       set sort_order = (select api_TestSortOrder(n_kit_id, n_t_test_id))
     where kit_id = n_kit_id
       and t_test_id = n_t_test_id;
    
  end loop; 	
	close t_cur;    
    
  return 1;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `xx_trackingID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` FUNCTION `xx_trackingID`(v_shipper varchar(5)) RETURNS varchar(100) CHARSET utf8
begin
    declare returnStr varchar(100);
    declare allowedChars varchar(100);
    declare i integer;
	declare length integer;
    
    set i = 0;
    set returnStr = '';
    
	case v_shipper
      when 'UPS' then
        set allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        set length = 26;
      when 'FEDEX' then
        set allowedChars = '0123456789';
        set length  = 12;
      when 'USPS' then
        set allowedChars = '0123456789';
        set length = 50;
	  else
        set allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        set length = 5;
	end case;
    
    while (i < length) do
        set returnStr = concat(returnStr, substring(allowedChars, floor(rand() * length(allowedChars) + 1), 1));
        set i = i + 1;
    end while;

    return concat(v_shipper, '_', returnStr);
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_canUpdateAccountDemographics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_canUpdateAccountDemographics`(
in_account_id BIGINT(20))
BEGIN
	select identity_approved from covid19_evaluations where account_id = in_account_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_checkRequisitionStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_checkRequisitionStatus`()
begin
	  
  
     
     
     
	  select re.requisition_id, r.submission_id, re.event_desc
	  from   ec_requisition_events re, ec_requisitions r
	  where re.requisition_event_id in 
		 (  select    max(re1.requisition_event_id)
			from      ec_requisition_events re1
			group by  re1.requisition_id  ) 
	   and (upper(re.event_desc) = 'PENDING' or upper(re.event_desc) = 'APPROVED')
	   and upper(re.event_type) = 'ORDER'
	   and re.requisition_id = r.requisition_id;
	
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_chordDiagram` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_chordDiagram`(in_kit_id bigint(20))
proc_label: begin
	declare n_null_response_count int(4) default 0;

	declare v_gender varchar(6);
    
    declare v_category_sql varchar(20000);
    declare v_categories varchar(5000);
    declare v_category_colors varchar(2000);
    
    declare v_question_sql varchar(20000);
    declare v_questions varchar(5000);
    declare v_question_colors varchar(5000);
	
    declare n_multiplier decimal(6,3);
    
    declare v_sql text;
    declare n_t_panel_id bigint(20) default null;
    
    declare n_sum_values int(4) default 0;
	declare n_sum_questions int(3) default 0;
    
    set session group_concat_max_len = 100000;
    
    
     select  left(ud.gender,1) into v_gender
      from  ec_kits k, ec_requisitions r, ec_user_demographics ud
	 where  k.kit_id = in_kit_id
       and  k.requisition_id = r.requisition_id
       and  r.user_id = ud.user_id;
    
    

	select distinct p.t_panel_id into n_t_panel_id
	  from ec_panels p, ec_t_panels_t_questions_map pqm, ec_t_questions tq
	 where p.kit_id = in_kit_id
	   and pqm.t_panel_id = p.t_panel_id
	   and pqm.t_question_id = tq.t_question_id
	   and tq.group = 'Symptom Review'
	 limit 1;
 
	if n_t_panel_id is null then
		leave proc_label;
	end if;
 
	
    select count(q.t_question_id) into n_null_response_count
	  from ec_t_questions tq, ec_t_panels_t_questions_map qm, ec_questions q
	 where qm.t_panel_id = n_t_panel_id
	   and qm.t_question_id = tq.t_question_id
	   and tq.group = 'Symptom Review'
	   and (tq.gender is null or tq.gender = v_gender)
	   and q.kit_id = in_kit_id
	   and q.t_question_id = tq.t_question_id
	   and q.response is null;
 
	if n_null_response_count > 0 then
		leave proc_label;
	end if;
 
    
    
    select	sum(li.sequence-1) into n_sum_values
	  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, ec_chord_categories c, ec_chord_categories_t_question_map cqm
	 where  m.t_panel_id = n_t_panel_id
	   and  m.t_question_id = tq.t_question_id
	   and  q.response is not null
	   and  q.t_question_id = tq.t_question_id
	   and  tq.group in ('Symptom Review') 
	   and  q.kit_id = in_kit_id
	   and  dt.data_type_id = q.data_type_id
	   and  dt.list_id = li.list_id
	   and  q.response = li.item
       and  c.chord_category_id = cqm.chord_category_id
	   and  cqm.t_question_id = tq.t_question_id
       and  cqm.gender = v_gender
       and  li.sequence > 1;
    
     
	 select sum(sequence-1) into n_sum_questions
	   from (
				select	distinct li.sequence, q.question
				  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, ec_chord_categories c, ec_chord_categories_t_question_map cqm
				 where  m.t_panel_id = n_t_panel_id
				   and  m.t_question_id = tq.t_question_id
				   and  q.response is not null
				   and  q.t_question_id = tq.t_question_id
				   and  tq.group in ('Symptom Review') 
				   and  q.kit_id = in_kit_id
				   and  dt.data_type_id = q.data_type_id
				   and  dt.list_id = li.list_id
				   and  q.response = li.item
				   and  c.chord_category_id = cqm.chord_category_id
				   and  cqm.t_question_id = tq.t_question_id
                   and  cqm.gender = v_gender
				   and  li.sequence > 1
			  ) t;
        
	set n_multiplier = n_sum_values / n_sum_questions;
        
    
    
    select group_concat(concat('coalesce(max(case when col = ''', col, ''' then value end),0)', ','',''') order by a, col desc),
           group_concat(concat('''"',col,'"''') order by a, col desc),
           group_concat('''"#000000"''')
	  into v_question_sql, v_questions, v_question_colors
	from
	(
       select distinct *
         from (
				select	tq.question as col, a
				  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, ec_chord_categories c, ec_chord_categories_t_question_map cqm,
							(select avg(sequence) a, t_question_id
											from (                
												select  tq.t_question_id, c.category, li.sequence
												  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, 
														 ec_chord_categories c, ec_chord_categories_t_question_map cqm
												 where  m.t_panel_id =  n_t_panel_id
												   and  m.t_question_id = tq.t_question_id
												   and  q.response is not null
												   and  q.t_question_id = tq.t_question_id
												   and  tq.group in ('Symptom Review')
												   and  q.kit_id = in_kit_id
												   and  dt.data_type_id = q.data_type_id 
												   and  dt.list_id = li.list_id
												   and  q.response = li.item
												   and  c.chord_category_id = cqm.chord_category_id
												   and  cqm.t_question_id = tq.t_question_id
												   and  cqm.gender = v_gender
												   and  li.sequence > 1) t
											group by t_question_id) t2   
				 where  m.t_panel_id = n_t_panel_id
				   and  m.t_question_id = t2.t_question_id
				   and  m.t_question_id = tq.t_question_id
				   and  q.response is not null
				   and  q.t_question_id = tq.t_question_id
				   and  tq.group in ('Symptom Review') 
				   and  q.kit_id = in_kit_id
				   and  dt.data_type_id = q.data_type_id
				   and  dt.list_id = li.list_id
				   and  q.response = li.item	
				   and  c.chord_category_id = cqm.chord_category_id
				   and  cqm.t_question_id = tq.t_question_id
				   and  cqm.gender = v_gender
				   and  li.sequence > 1
			)d
		)d2;

	
    select group_concat(distinct concat('coalesce(max(case when col = ''', col, ''' then value end),0)', ','',''') order by rank desc, col),
           group_concat(distinct concat('''"',col,'"''') order by rank desc, col),
           group_concat(distinct concat('''"',color,'"''') order by rank desc, col)
	  into v_category_sql, v_categories, v_category_colors
	from
	(
		select	c.category as col, sum(li.sequence-1) rank, c.color
		  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, 
				ec_chord_categories c, ec_chord_categories_t_question_map cqm
		 where  m.t_panel_id = n_t_panel_id
		   and  m.t_question_id = tq.t_question_id
		   and  q.response is not null
		   and  q.t_question_id = tq.t_question_id
		   and  tq.group in ('Symptom Review')
		   and  q.kit_id = in_kit_id
		   and  dt.data_type_id = q.data_type_id
		   and  dt.list_id = li.list_id
		   and  q.response = li.item
		   and  c.chord_category_id = cqm.chord_category_id
		   and  cqm.t_question_id = tq.t_question_id
		   and  li.sequence > 1
           and  cqm.gender = v_gender
		   and  c.category_type = 'Hormone'
		 group
            by  c.category		
	)d;
    
   
   select trim(trailing ','',''' from v_question_sql) into v_question_sql;

   
   SET SQL_SAFE_UPDATES = 0;
   delete from ec_chord_data where kit_id = in_kit_id and category_type = 'Hormone';
    
    
    
    set v_sql = concat(
    
	   'insert into ec_chord_data (category_type, kit_id, created_at, updated_at, chord_data)
    
        select ''Hormone'',', in_kit_id,',now(), now(), concat(''[['', group_concat(chord_data separator ''],['') ,'']]'') as chord_data 
    
		from (
        
			    select concat_ws('','' ,',v_categories,',', v_questions, ') as chord_data, 999999 as rank, ''category'' as category, 1 as rec_type
        
				union 
                
                select concat_ws('','' ,',v_category_colors,',', v_question_colors, ') as chord_data, 999998 as rank, ''category'' as category, 1 as rec_type
        
				union ',
			
				'select concat(', v_category_sql, ',', v_question_sql,') as chord_data, 
						case when rec_type = ''question'' then 9000 - a else 9000 + sum(value) end as rank,
						category,
                        rec_type
				 from  (
						 select * 
						   from (
								 select  c.category, tq.question as col, li.sequence-1 as value, ''category'' as rec_type, 1 as a
										  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, 
												ec_chord_categories c, ec_chord_categories_t_question_map cqm
										 where  m.t_panel_id = ', n_t_panel_id, '
										   and  m.t_question_id = tq.t_question_id
										   and  q.response is not null
										   and  q.t_question_id = tq.t_question_id
										   and  tq.group in (''Symptom Review'')
										   and  q.kit_id = ', in_kit_id, '
										   and  dt.data_type_id = q.data_type_id
										   and  dt.list_id = li.list_id
										   and  q.response = li.item
										   and  c.chord_category_id = cqm.chord_category_id
										   and  cqm.t_question_id = tq.t_question_id
                                           and  cqm.gender = ''',v_gender,'''
										   and  li.sequence > 1
								  union         
								  select  tq.question as category, c.category as col, (li.sequence-1)*multiplier as value, ''question'' as rec_type, a
										  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, 
												ec_chord_categories c, ec_chord_categories_t_question_map cqm,
												 (                                             
													 select avg(sequence) a,
															(avg(sequence) * ',n_multiplier,' - avg(sequence) * 1.5) / (count(sequence) * avg(sequence)) multiplier, 
															t_question_id
													 from (                
															select  tq.t_question_id, c.category, li.sequence
															  from	ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li, 
																	 ec_chord_categories c, ec_chord_categories_t_question_map cqm
															 where  m.t_panel_id = ',n_t_panel_id,'
															   and  m.t_question_id = tq.t_question_id
															   and  q.response is not null
															   and  q.t_question_id = tq.t_question_id
															   and  tq.group in (''Symptom Review'')
															   and  q.kit_id = ', in_kit_id,'
															   and  dt.data_type_id = q.data_type_id 
															   and  dt.list_id = li.list_id
															   and  q.response = li.item
															   and  c.chord_category_id = cqm.chord_category_id
															   and  cqm.t_question_id = tq.t_question_id
                                                               and  cqm.gender = ''',v_gender,'''
															   and  li.sequence > 1																																	
															) t
													   group by t_question_id
												   ) t2                                
										 where  m.t_panel_id = ',n_t_panel_id,'
										   and  m.t_question_id = t2.t_question_id
										   and  m.t_question_id = tq.t_question_id
										   and  q.response is not null
										   and  q.t_question_id = tq.t_question_id
										   and  tq.group in (''Symptom Review'')
										   and  q.kit_id = ', in_kit_id, '
										   and  dt.data_type_id = q.data_type_id
										   and  dt.list_id = li.list_id
										   and  q.response = li.item
										   and  c.chord_category_id = cqm.chord_category_id
										   and  cqm.t_question_id = tq.t_question_id
                                           and  cqm.gender = ''',v_gender,'''
										   and  li.sequence > 1                                   
										 union 
										select  distinct tq.question as category, tq.question as col, (li.sequence-1)*1.5 as value, ''question'' as rec_type, li.sequence as a
										  from  ec_t_questions tq, ec_questions q, ec_t_panels_t_questions_map m, ec_data_types dt, ec_list_items li,
                                                ec_chord_categories_t_question_map cqm
										 where  m.t_panel_id = ',n_t_panel_id,'
										   and  m.t_question_id = tq.t_question_id
										   and  q.response is not null
										   and  q.t_question_id = tq.t_question_id
										   and  tq.group in (''Symptom Review'')
										   and  q.kit_id = ', in_kit_id, '
										   and  dt.data_type_id = q.data_type_id 
										   and  dt.list_id = li.list_id
										   and  q.response = li.item
                                           and  cqm.t_question_id = tq.t_question_id
                                           and  cqm.gender = ''',v_gender,'''
										   and  li.sequence > 1		                                                                      
								) d1
							)d                     
				group by category 
                order by rank desc, 
                         (case when rec_type = ''question'' then category end) desc,
                         (case when rec_type <> ''question'' then category end) asc 
			) t;'
	);

    if v_sql is not null then
		set @v_sql = v_sql;
		
		prepare stmt from @v_sql;
		execute stmt;
		deallocate prepare stmt;
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createClinicalLabDataFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createClinicalLabDataFromPartner`(
	in_json json,
    in_partner_user_id varchar(255),
    in_partner_name varchar(255)
)
begin
  declare n_partner_id bigint(20) default (select api_getPartnerIdFromName(in_partner_name));
    
  insert into ptnr_clinicallabdata
    (user_id, partner_id, clinicallab_json, created_at, updated_at)
  values
    ( (select api_getUserIdFromPartner(in_partner_user_id, n_partner_id)), n_partner_id, in_json, now(), now());

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createClinicalLabFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createClinicalLabFromPartner`(
    in_partner_user_id varchar(255),
    in_partner_name varchar(255),
    in_pdf mediumblob,
    out out_clinical_lab_id bigint(20)
)
begin
	declare n_partner_id bigint(20) default (select api_getPartnerIdFromName(in_partner_name));
	
    insert into ptnr_clinical_labs
    (
        user_id, 
        partner_id, 
        created_at, 
        updated_at
	)
	values
    (
        (select api_getUserIdFromPartner(in_partner_user_id, n_partner_id)), 
        n_partner_id, 
        now(), 
        now()
	);

	select last_insert_id() into out_clinical_lab_id;
    
    if (in_pdf is not null) then
    
	  insert into ec_attachments
        (attachment, object_type, object_id, created_at, updated_at)
      values
        (in_pdf, 'ptnr_clinical_labs', out_clinical_lab_id, now(), now());
    
    end if;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createClinicalLabResultFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createClinicalLabResultFromPartner`(
	in_clinical_lab_id bigint(20),
	in_result_date varchar(19),
    in_lower_range decimal(10,2),
    in_upper_range decimal(10,2),
    in_result decimal(10,2),
    in_test_name varchar(40),
    in_attribute varchar(255),
    in_sequence int(3)
)
begin
  declare n_attribute_id bigint(20) default null;
  
  if (in_attribute is not null) then
    
	select attribute_id into n_attribute_id from ptnr_attributes pa where pa.attribute = in_attribute;
		
	if (n_attribute_id is null) then
		
		insert into ptnr_attributes (attribute, created_at, updated_at) values (in_attribute, now(), now() );
		select last_insert_id() into n_attribute_id;
	end if;
  end if;
  
  insert into ptnr_clinical_lab_results 
  (
    clinical_lab_id,
    result_date,
    test_name,
    attribute_id,
    result,
    lower_range,
    upper_range,
    sequence,
    created_at,
    updated_at
  ) 
  values 
  (
	in_clinical_lab_id,
	str_to_date(in_result_date,  '%Y-%m-%d %T'), 
    in_test_name,
    n_attribute_id,
    in_result,
    in_lower_range,
    in_upper_range,
    in_sequence,
    now(),
    now()
  );

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createForcePlateDataFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createForcePlateDataFromPartner`(
	in_json json,
    in_partner_user_id varchar(255),
    in_partner_name varchar(255)
)
begin
  declare n_partner_id bigint(20) default (select api_getPartnerIdFromName(in_partner_name));
    
  insert into ptnr_forceplatedata
    (user_id, partner_id, forceplate_json, created_at, updated_at)
  values
    ( (select api_getUserIdFromPartner(in_partner_user_id, n_partner_id)), n_partner_id, in_json, now(), now());

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createGeneDataFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createGeneDataFromPartner`(
    in_json json,
    in_partner_user_id varchar(255),
    in_partner_name varchar(255)
)
begin
  declare n_partner_id bigint(20) default (select api_getPartnerIdFromName(in_partner_name));
    
  insert into ptnr_genedata
    (user_id, partner_id, genedata_json, created_at, updated_at)
  values
    ( (select api_getUserIdFromPartner(in_partner_user_id, n_partner_id)), n_partner_id, in_json, now(), now());

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createMedicalHistoryFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createMedicalHistoryFromPartner`(
	in_json json,
    in_partner_user_id varchar(255),
    in_partner_name varchar(255)
)
begin
  declare n_partner_id bigint(20) default (select api_getPartnerIdFromName(in_partner_name));
    
  insert into ptnr_medhistory
    (user_id, partner_id, medhistory_json, created_at, updated_at)
  values
    ( (select api_getUserIdFromPartner(in_partner_user_id, n_partner_id)), n_partner_id, in_json, now(), now());

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createMicrobiomeDataFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createMicrobiomeDataFromPartner`(
	in_json json,
    in_partner_user_id varchar(255),
    in_partner_name varchar(255)
)
begin
  declare n_partner_id bigint(20) default (select api_getPartnerIdFromName(in_partner_name));
    
  insert into ptnr_microbiomedata
    (user_id, partner_id, microbiome_json, created_at, updated_at)
  values
    ( (select api_getUserIdFromPartner(in_partner_user_id, n_partner_id)), n_partner_id, in_json, now(), now());

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_createUserFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_createUserFromPartner`(
	in_email varchar(255), 
    in_encrypted_password varchar(255), 
    in_reset_password_token varchar(255),
	in_reset_password_sent_at varchar(19), 
    in_remember_created_at varchar(19),
	in_first_name varchar(255), 
    in_last_name varchar(255), 
    in_address1 varchar(255), 
    in_address2 varchar(255),
	in_city varchar(255), 
    in_state varchar(255), 
    in_zip varchar(10), 
    in_phone varchar(15), 
    in_mobile varchar(15),
    in_dob varchar(10),
    in_gender varchar(1),
    in_height_in mediumint(9),
    in_weight_lbs mediumint(9),
    in_race varchar(20),
    in_partner_user_id varchar(255),
    in_partner_name varchar(255),
    in_barcode varchar(20)
    
)
begin
	declare n_user_id int(11) default null;
    declare n_partner_id bigint(20) default null;
    declare n_out_req bigint(20);
    
    
	insert into ec_users 
	(
		email, 
		encrypted_password, 
        reset_password_token, 
        reset_password_sent_at, 
        remember_created_at, 
		first_name, 
        last_name, 
        address1, 
        address2, 
        city, 
        state, 
        zip, 
        phone, 
        mobile,
        created_at,
        updated_at
	)
	values 
	(
		in_email, 
        in_encrypted_password, 
        in_reset_password_token, 
        str_to_date(in_reset_password_sent_at,  '%m/%d/%Y %T'), 
		str_to_date(in_remember_created_at,     '%m/%d/%Y %T'), 
        in_first_name, 
        in_last_name, 
        in_address1, 
        in_address2, 
        in_city, 
        in_state, 
        in_zip, 
        in_phone, 
        in_mobile,
        now(),
        now()
	);

	select last_insert_id() into n_user_id;
    
    
    insert into ec_user_demographics 
    (
		user_id, 
        birthdate, 
        gender, 
        height_in, 
        weight_lbs, 
        created_at, 
        updated_at
	)
    values 
    (
		n_user_id, 
        str_to_date(in_dob,  '%m/%d/%Y'),
        in_gender,
        in_height_in,
        in_weight_lbs,
        now(),
        now()
	);
    
    
    select partner_id into n_partner_id from ec_partners where name = in_partner_name;
    if (n_partner_id is not null) then
		insert into ec_users_partners_map (user_id, partner_id, partner_user_id) values (n_user_id, n_partner_id, in_partner_user_id); 
	end if;
    
    
    if (in_barcode is not null and length(in_barcode) > 0) then
		call ec_create_requisition(n_user_id, in_barcode, n_out_req);
        update ec_kits set status = 'SUBMITTED' where barcode = in_barcode;
    end if;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_deleteManifestRequisitions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_deleteManifestRequisitions`(in_requisition_manifest_ids text)
begin
	delete from ec_requisition_manifests where find_in_set(requisition_manifest_id, in_requisition_manifest_ids) and requisition_manifest_id > 0;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getAccountDemographics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getAccountDemographics`(in_account_id bigint)
begin
select 
		ac.id as account_id, 
        ac.email, 
        p.name partnername, 
        ad.full_legal_name name, 
        ad.date_of_birth birthday, 
        ad.address, 
        ad.phone_number phone,
        ad.state_of_residence state, 
        ad.gender, 
        ifnull(ev.identity_approved, 0) IsConfirmed
    from accounts ac 
    
    left join account_demographics ad on ac.id = ad.account_id
	left join account_access_grants aag on aag.account_id = ad.account_id
	left join partner_access_codes pac on pac.id = aag.partner_access_code_id
	left join ec_partners p on p.partner_id = pac.partner_id
    left join covid19_evaluations ev on ev.account_id= in_account_id and ev.id = (select max(id) from covid19_evaluations where account_id=in_account_id)
    where ac.id = in_account_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getApiStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getApiStatus`()
begin

	  select 'api_order_error_logs' as tablename, substring_index( substring_index(response, '<errors>', -1), '</errors>', 1) as event_text, created_at
		from api.api_order_error_logs   
	   where created_at > curdate() - 2
	   union
	  select 'api_pwn_notify_logs' as tablename, concat(customer_id, ' ', event) as event_text, created_at
		from api.api_pwn_notify_logs    
	   where created_at > curdate() - 2
	   union
	  select 'api_result_logs' as tablename, barcode as event_text, created_at
		from api.api_result_logs       
	   where created_at > curdate() - 2
	   union
	  select 'api_user_incoming_logs' as tablename, 
			 concat('api_users.user_id ', user_id, ' ',
			   case when lower(user_json) like '%medical_history%' then 'medical_history'
					when lower(user_json) like '%force_plate%' then 'force_plate'
					when lower(user_json) like '%microbiome%' then 'microbiome'
					when lower(user_json) like '%clincial_labs%' then 'clincial_labs'
					when lower(user_json) like '%"dob"%' then 
						concat('user + barcode ', substring_index( substring_index(user_json, '"ehs_id": "', -1), '",', 1))
			   end
			 ) as event_text, 
			 created_at 
		from api.api_user_incoming_logs        
	   where created_at > curdate() - 2
	   union
	  select 'api_user_outgoing_logs' as tablename, concat(user_name, ' ', endpoint, ' ', post_response) as event_text, created_at 
		from api.api_user_outgoing_logs 
	   where created_at > curdate() - 2
	order by tablename, created_at desc;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getConsumerResultsEmailInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getConsumerResultsEmailInfo`(in_barcode varchar(20))
begin
	select u.user_id, u.first_name, u.last_name, u.email, (select value from ec_config where name = 'support_email') as reply_to,
		   tk.name as kit_name, k.kit_id
	  from ec_requisitions r, ec_users u, ec_kits k, ec_t_kits tk
	 where r.user_id        = u.user_id
       and r.requisition_id = k.requisition_id
       and k.barcode        = in_barcode
       and k.t_kit_id       = tk.t_kit_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getEncryptedUserPassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getEncryptedUserPassword`(
	in_user_email varchar(255)    
)
begin
  select encrypted_password, user_id from ec_users where email = in_user_email;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getHealthPassport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getHealthPassport`(in_user_id bigint)
begin
	select 
		ev.identity_approved,
		evst.status_enum,
		case 
			when igm_result is not null and igm_result != 0 then igm_result
			else 0
		end as serology_results_sumitted,
		case 
			when pcr_result is not null and pcr_result != 0 then pcr_result
			else 0
		end as pcr_results_sumitted
	from 
		covid19_evaluations ev
		left join covid19_evaluation_statuses evst on ev.status = evst.status_code
	where
		ev.account_id = in_user_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getKitId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getKitId`(in_barcode varchar(20))
begin
   select kit_id from ec_kits where barcode = in_barcode;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getLabOrders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getLabOrders`(in in_account_id bigint)
begin
	select tk.name as `name`,
		concat(tp.first_name, ' ', tp.last_name) as `orderingName`,
		k.barcode as `patientCaseId`,
		tp.npi,
		tp.phone,
        r.updated_at as labDate,
		group_concat(q.question separator ',') as indications
	from accounts a, ec_requisitions r, ec_kits k, ec_t_kits tk, telemedicine_physicians tp, ec_questions q
	where a.user_id = r.user_id
		and r.requisition_id = k.requisition_id
		and k.t_kit_id = tk.t_kit_id
		and r.telemedicine_physician_id = tp.telemedicine_physician_id
		and q.kit_id = k.kit_id
		and q.response is not null
		and lower(q.response) = 'yes'
		and a.id = in_account_id
	group 
		by tk.name, tp.first_name, tp.last_name, r.requisition_id, tp.phone, r.updated_at;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getLabRejection` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getLabRejection`(in_rejection_text varchar(255), in_barcode varchar(20))
begin

   select lr.lab_rejection_id, lrr.response_text, k.kit_id
     from ec_lab_rejections lr, ec_lab_rejection_responses lrr, ec_kits k, ec_t_kits tk
	where lower(lr.rejection_text) = lower(in_rejection_text)
      and lrr.lab_rejection_id = lr.lab_rejection_id
      and lr.lab_id = tk.lab_id
      and tk.t_kit_id = k.t_kit_id
      and k.barcode = in_barcode;
	
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getManifestRequisitions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getManifestRequisitions`()
begin
   
   
   select 	rm.requisition_manifest_id, r.submission_id, 
			u.last_name, u.first_name, u.address1, u.address2, u.city, u.state, u.zip,
            ud.birthdate, ud.gender, 
            tk.name as test_name,
            pp.name as physician_name, pp.npi,
            k.barcode,
            l.manifest_emails, l.manifest_password, l.name as lab_name, 
            (select value from ec_config where name = 'support_email') as reply_to
	  from 	ec_requisition_manifests rm, ec_requisitions r, ec_kits k, ec_t_kits tk, ec_labs l, ec_users u, ec_user_demographics ud,
			ec_pwn_physicians_reqs_map pm, ec_pwn_physicians pp
	 where 	rm.requisition_id = r.requisition_id
       and 	k.requisition_id = r.requisition_id
	   and 	k.t_kit_id = tk.t_kit_id
	   and 	tk.lab_id = l.lab_id
       and 	r.user_id = u.user_id
       and 	ud.user_id = u.user_id
       and 	pm.requisition_id = r.requisition_id
       and 	pm.pwn_physician_id = pp.pwn_physician_id
	   and  l.manifest_password is not null
	   and 	l.manifest_emails is not null
  order by 	requisition_manifest_id;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getMessages` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getMessages`(in_account_id bigint)
begin
	select
		ev.id as evaluation_id,
		ev.status as evaluation_status,
		rr.id as rejection_reason_id,
		rrc.rejection_code_enum as rejection_code, 
		rr.resolved as resolved,
        null as message_id,
        null as message_code,
        null as message_subject,
        null as message_copy
	from 
		covid19_rejection_reasons rr
		inner join covid19_evaluations ev on rr.covid19_evaluation_id = ev.id
		inner join covid19_rejection_reason_codes rrc on rrc.rejection_reason_code = rr.rejection_code
	where 
		ev.account_id = in_account_id
                
	union
    
    select
		null as evaluation_id,
		null as evaluation_status,
		null as rejection_reason_id,
		null as rejection_code, 
		cm.resolved as resolved,
        cm.covid19_message_id as message_id,
        cmc.message_code,
        cmc.message_subject,
        cmc.message_copy
	from 
        covid19_messages cm, covid19_message_codes cmc
	where 
		cm.message_code = cmc.message_code
        and cm.account_id = in_account_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getNewCoachComments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getNewCoachComments`()
begin
	 select  cc.coach_comment_id, 
			date(cc.updated_at) comments_date,
            upm.partner_user_id,
            p.name as partner_name,
            cc.comment as test_names
      from  ec_coach_comments cc, ec_coach_sessions cs, ec_partners p, ec_users_partners_map upm
	 where  cc.coach_session_id = cs.coach_session_id
       and  cs.partner_id  = p.partner_id
       and  upm.partner_id = p.partner_id
       and  upm.user_id    = cs.user_id
       and  cc.comment is not null 
       and  length(cc.comment) > 0
       and  (cc.status is null or lower(cc.status) <> 'transmitted');
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getNewCoachSessions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getNewCoachSessions`()
begin
	select  cs.coach_session_id, cs.session_start, cs.session_stop, cs.session_notes, cs.created_at, cs.updated_at,
            map.partner_user_id,
            p.name as partner_name,
            'Provider Name' as provider_name
      from  ec_coach_sessions cs, ec_users_partners_map map, ec_partners p
	 where  cs.user_id = map.user_id
       and  map.partner_id = p.partner_id
       and  lower(cs.status) = 'complete';
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getNewLabDataResults` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getNewLabDataResults`()
begin
   select ld.lab_data_id, ld.lab_id, ld.status, ld.file_type, ld.data,
          l.name, l.receiving_application as sending_application, l.receiving_facility as sending_facility
     from ec_lab_data ld, ec_labs l
	where lower(ld.status) = 'new'
      and ld.lab_id = l.lab_id;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getNewOrders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getNewOrders`()
begin
	
    
    select barcode, approval_path, group_concat(order_code) order_code, group_concat(order_name) order_name, requisition_id, collection_date, user_id, first_name, last_name,
		   address1, address2, city, state, zip, phone, email, birthdate, gender, type_of, fasting, receiving_application, receiving_facility,
           npi, prov_first_name, prov_last_name, last_period_first_day, menses           
	from (
			select   distinct k.barcode,
                     tk.approval_path,
					 case when upper(tk.approval_path) = 'LAB' then tp.lab_order_code 
															   else tp.pwn_order_code
					 end as order_code,
                     
                     tp.name as order_name,
                     
					 r.requisition_id, r.created_at as collection_date,			 
					 u.user_id, u.first_name, u.last_name, u.address1, u.address2, u.city, u.state, u.zip, u.phone, u.email,
					 ud.birthdate, ud.gender, 
                     
					 case when ud.gender = 'F' then (select api_getMenstrualFirstDay(k.kit_id))
					      else null 
					 end as last_period_first_day, 
                     
                     case when ud.gender = 'F' then (select api_getMenstrualStatus(k.kit_id))
                          else null 
					 end as menses,                     
					                   
					 prt.type_of, 
					 null as fasting,
                     l.receiving_application, l.receiving_facility,
                     cp.npi, cp.first_name as prov_first_name, cp.last_name as prov_last_name
                     
			 from    ec_kits k, 
					 ec_requisitions r left join ec_clinic_physicians cp on r.clinic_physician_id = cp.clinic_physician_id,
					 
					 ec_user_demographics ud, 
					 ec_t_kits tk, 
					 
					 ec_panels pan,
					 ec_t_panels tp,
                     ec_labs l,
                     ec_users u,
                     
                     ec_partners prt
                     
			 where   r.requisition_id = k.requisition_id             
			 and     u.user_id = ud.user_id
			 and     r.user_id = u.user_id
			 and     k.partner_id = prt.partner_id
			 and     (tp.lab_order_code is not null or tp.pwn_order_code is not null) 
			 and     k.t_kit_id = tk.t_kit_id
			 and     pan.kit_id = k.kit_id
			 and     pan.t_panel_id = tp.t_panel_id
             and     tk.lab_id = l.lab_id
			 and     r.submission_id is null 
             and     lower(k.status) = 'submitted'
		) t
     
     group by barcode, requisition_id, collection_date, user_id, first_name, last_name,
		   address1, address2, city, state, zip, phone, email, birthdate, gender, type_of, fasting, 
           receiving_application, receiving_facility, npi, prov_first_name, prov_last_name,
           last_period_first_day, menses;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getOrCreateTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_getOrCreateTest`(
in_account_id bigint(20)
)
BEGIN
	declare test_id bigint(20);

	select t.id testid into test_id from covid19_tests t
	left join covid19_test_results tr on tr.covid19_test_id = t.id
	where t.account_id=in_account_id and (tr.uploaded is null OR tr.uploaded = 0)
    LIMIT 1;
    
    if (test_id is null) then
		insert into covid19_tests (account_id, created_at, updated_at) values (in_account_id, now(), now());
        
        SELECT LAST_INSERT_ID() into test_id;
    end if;
    
    select test_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getOrInsertIdentity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getOrInsertIdentity`(in in_account_id bigint)
begin
	declare existing_id bigint(20) default 0;

    select id 
    into existing_id
    from identities
    where account_id = in_account_id;

    if existing_id > 0 then
        select existing_id;
    else
		insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
			values (in_account_id, now(), '', '', '', now(), now());
		select last_insert_id();
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getPartnerAccessCodeId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_getPartnerAccessCodeId`(
accessCode varchar(50)
)
BEGIN
	select id from partner_access_codes where access_code = accessCode;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getPartnerByAccessCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_getPartnerByAccessCode`(
accessCode varchar(50)
)
BEGIN
	select p.id, p.name from ec_partners p
    inner join 
		parter_access_codes pac on pac.partner_id = p.partner_id
    where 
		pac.access_code = accessCode;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getPartnerContact` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getPartnerContact`(in_barcode varchar(20))
begin
	select p.partner_id, p.name, p.email, (select value from ec_config where name = 'support_email') as reply_to
	  from ec_kits k, ec_partners p
	 where k.barcode = in_barcode
	   and k.partner_id = p.partner_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getPartnerUserInfoFromBarcode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getPartnerUserInfoFromBarcode`(
	in_barcode varchar(20)
)
begin
	
	select 	p.name as partner_name, pm.partner_user_id
	  from	ec_kits k, ec_requisitions r, ec_users_partners_map pm, ec_partners p
	 where  k.barcode = in_barcode
       and  k.requisition_id = r.requisition_id
	   and  r.user_id = pm.user_id
	   and  pm.partner_id = p.partner_id
	   and  k.partner_id = p.partner_id; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getPortalUserByEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_getPortalUserByEmail`(in_email varchar(40))
begin
	select u.id, u.encrypted_password encryptedpassword, u.email, p.name partnerName, u.user_id userid
      from accounts u
      inner join account_access_grants aag on aag.account_id = u.id
      inner join partner_access_codes pac on pac.id = aag.partner_access_code_id
      inner join ec_partners p on p.partner_id = pac.partner_id
	 where u.email = in_email;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getPortalUserById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_getPortalUserById`(userId bigint(20))
begin
	select u.email, u.encrypted_password encryptedpassword, u.id, confirmed_at ConfirmedAt, p.name partnername
      from accounts u
      inner join account_access_grants aag on aag.account_id = u.id
      inner join partner_access_codes pac on pac.id = aag.partner_access_code_id
      inner join ec_partners p on p.partner_id = pac.partner_id
	 where u.id = userId;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getPortalUserVerify` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getPortalUserVerify`(in_user_id bigint(20))
begin
	select uv.portrait_consent, uv.portrait_status, uv.id_status, uv.verified, uv.loa, uv.identity
      from ec_user_verify uv
	 where uv.user_id = in_user_id;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getReferenceRange` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getReferenceRange`(in_barcode varchar(20), in_sequence int(3), in_testname varchar(45))
begin
	declare v_gender varchar(1) default 'M';
    declare n_age int(3) default 0;
    declare n_lab_id bigint(20) default 0;
    
    
	select left(ud.gender,1),
		   date_format(now(), '%Y') - date_format(ud.birthdate, '%Y') - (date_format(now(), '00-%m-%d') < date_format(ud.birthdate, '00-%m-%d')),
           tk.lab_id
           into v_gender, n_age, n_lab_id
	  from ec_kits k, ec_requisitions r,ec_user_demographics ud, ec_t_kits tk
	 where k.barcode = in_barcode
       and k.requisition_id = r.requisition_id
       and ud.user_id = r.user_id
       and k.t_kit_id = tk.t_kit_id;

	
    select abs(n_age - age) as diff, age, ref_range
    from 
		(
		select date_format(now(), '%Y') - date_format(ud.birthdate, '%Y') - (date_format(now(), '00-%m-%d') < date_format(ud.birthdate, '00-%m-%d')) as age, 
			   t.ref_range
		  from ec_tests t, ec_kits k, ec_requisitions r, ec_user_demographics ud, ec_t_kits tk
		 where lower(t.test_name) like concat(lower(in_testname),'%')
		   and t.sequence         = in_sequence
		   and t.kit_id           = k.kit_id
		   and k.requisition_id   = r.requisition_id
		   and ud.user_id         = r.user_id
		   and left(ud.gender, 1) = v_gender
           and k.t_kit_id         = tk.t_kit_id
           and tk.lab_id          = n_lab_id
	   ) t1
       order by diff, age
       limit 1;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getReminderEmails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getReminderEmails`()
begin
	select u.user_id,
          u.email,
		  u.first_name,
          k.kit_id,
		  k.barcode,          
		  r.updated_at,
          p.name as partner_name,
          tk.name as kit_name,
          (select value from ec_config where name = 'support_email') as reply_to
	 from ec_kits k,
		  ec_requisitions r,
		  ec_users u,
          ec_partners p,
          ec_t_kits tk 
	where r.requisition_id = k.requisition_id
	  and upper(k.status) = 'ALLOCATED'
	  and u.user_id = r.user_id
      and r.updated_at < date_sub(now(), interval 14 day) 
      and k.partner_id = p.partner_id
      and k.t_kit_id = tk.t_kit_id
      and k.inbound_shipping_label is not null
      and k.inbound_tracking_id is not null
      and u.user_id not in (select user_id from ec_user_messages where upper(type_of) = 'REMINDER' and body like concat('%', k.barcode, '%'));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getShippedNoOrderText` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getShippedNoOrderText`(in_barcode varchar(20))
begin

   select lr.lab_rejection_id, lrr.response_text, k.kit_id
     from ec_lab_rejections lr, ec_lab_rejection_responses lrr, ec_kits k, ec_t_kits tk
	where lower(lr.rejection_text) like '%no electronic order%'
      and lrr.lab_rejection_id = lr.lab_rejection_id
      and lr.lab_id = tk.lab_id
      and tk.t_kit_id = k.t_kit_id
      and k.barcode = in_barcode;
	
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getSmtpConfig` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getSmtpConfig`()
begin
   
   
     select  variable, value
	   from  ec_config 
	  where  variable in ('smtp_password', 'smtp_port', 'smtp_server', 'smtp_user') 
   order by  variable;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getStepsStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getStepsStatus`(in_account_id bigint)
begin
	select  
        a.is_active,
        ev.status,
		evst.status_enum,
		coalesce(ev.identity_approved, 0) identity_approved,
        case when pp.passport_product_id = 1 
        and i.id_front_s3_key is not null 
				  and i.selfie_s3_key is not null 
			      and timestampdiff(minute, i.updated_at, now()) >= 30 then 1
             else 0
		end as identity_is_completed, 
		evrr.rejection_code,
		evrc.rejection_code_enum,
		evrr.description as rejection_description,
		coalesce(subjective_hpi_approved,0) subjective_hpi_approved,
        coalesce(lab_review_approved, 0) lab_review_approved,
        pp.passport_product_id, 
        pp.name as passport_name,
        pp.description as passport_description,
        pp.daily_survey,
        pp.identity_and_results,
	    coalesce(cdc.daily_checkup_status_code, 0) as daily_status_code,
        coalesce(cdcs.daily_checkup_status, 'Did Not Submit') as daily_status_text
 
  from  account_access_grants aag, partner_access_codes pac, ec_partners ep, passport_products pp,
		accounts a
                   left join identities i                        on i.account_id = a.id
				   left join covid19_evaluations ev              on a.id = ev.account_id
		           left join covid19_evaluation_statuses evst    on ev.status = evst.status_code
				   left join covid19_rejection_reasons evrr      on ev.id = evrr.covid19_evaluation_id
				   left join covid19_rejection_reason_codes evrc on evrr.rejection_code = evrc.rejection_reason_code
                   left join covid19_daily_checkups cdc          on cdc.account_id = a.id
                   left join covid19_daily_checkup_statuses cdcs on cdc.daily_checkup_status_code = cdcs.daily_checkup_status_code

  where a.id = in_account_id
    and aag.account_id = a.id
    and aag.partner_access_code_id = pac.id
    and pac.partner_id = ep.partner_id
    and ep.passport_product_id = pp.passport_product_id
    and (ev.id is null or ev.id = (select id from covid19_evaluations where account_id = in_account_id order by id desc limit 1))
    and (cdc.checkup_date is null or cdc.checkup_date = (select checkup_date from covid19_daily_checkups where account_id = in_account_id order by checkup_date desc limit 1));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getSurveyQuestions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getSurveyQuestions`(in_account_id bigint)
begin  
     select q.question_id, q.group, q.sub_group, q.question, q.response, q.required, dt.type_of, 
		   case when dt.list_id is not null then group_concat(li.item separator ',') else null end as `Options`
	  from ec_questions q, accounts a, ec_requisitions r, ec_kits k, 
		   ec_data_types dt, ec_lists l, ec_list_items li
	 where a.id = in_account_id
	   and a.user_id = r.user_id
	   and r.requisition_id = k.requisition_id
	   and k.kit_id = q.kit_id
	   and q.data_type_id = dt.data_type_id
	   and (dt.list_id = l.list_id or dt.list_id is null)
	   and li.list_id = l.list_id
	   and q.created_at = (select max(created_at) from ec_questions where kit_id = k.kit_id)
	 group by question_id, `group`, sub_group, question, response, required, type_of;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getTestResult` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getTestResult`(
	in_user_id bigint,
	in_test_id bigint
)
begin
    select r.*
	  from covid19_test_results r, covid19_tests t
	 where r.id = in_test_id
	   and r.covid19_test_id = t.id
	   and t.account_id = in_user_id
	   and r.uploaded = true;    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getTestResults` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getTestResults`(in_user_id bigint)
begin
	select results.*
    from covid19_tests tests
    inner join covid19_test_results results on results.covid19_test_id = tests.id
    where tests.account_id = in_user_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getTests` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getTests`(
	in_user_id long
)
BEGIN
	select 
		id,
        account_id,
        created_at,
        updated_at
	from
		`ecp-dev`.covid19_tests
	where 
		account_id = in_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getUserContact` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getUserContact`(in_requisition_id bigint(20))
begin
	select u.user_id, u.first_name, u.last_name, u.email, (select value from ec_config where name = 'support_email') as reply_to
	  from ec_requisitions r, ec_users u
	 where r.user_id = u.user_id
       and r.requisition_id = in_requisition_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getUserMedications` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getUserMedications`( in_req_id bigint(20))
begin
    
    select 	 trim(SUBSTRING_INDEX(sub_group, '-', -1)) as med_name,  trim(SUBSTRING_INDEX(response, '-', -1)) as med_type,
			 case when sub_group like '%Contracept%' then 1
				  else 0
             end as is_contraceptive, 
            null as dosage, 
            null as dosage_units
	from 	 ec_questions q, ec_kits k
	where	 k.requisition_id = in_req_id
	and		 k.kit_id = q.kit_id
	and 	 q.group = 'Medications'
	and      q.response like 'Yes%'
	order by med_name;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getUspsTrackingNumbers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getUspsTrackingNumbers`()
begin
	

	select	k.barcode,
			k.kit_id,
			k.requisition_id, 
			k.inbound_tracking_id as tracking_id, 
            k.status as kit_status, 
            re.event_type, 
            re.event_desc, 
            re.event_summary, 
            'Inbound' as tracking_type,
            tk.name as kit_name
	from	ec_kits k left join ec_requisition_events re on k.requisition_id = re.requisition_id,
            ec_t_kits tk
	where  	k.inbound_tracking_id is not null
    and     length(k.inbound_tracking_id) >= 20
	and     lower(k.status) in ('submitted', 'transit', 'allocated', 'active')
	and     k.requisition_id is not null
	and     (re.tracking_type is null or lower(re.tracking_type = 'inbound'))
	and     lower(re.event_type) in ('tracking', 'info')
    and     (re.event_summary is null or lower(re.event_summary) not in ('delivered'))
	and     re.requisition_event_id = (select max(re2.requisition_event_id) from ec_requisition_events re2 where re2.requisition_id = k.requisition_id)
    and     k.t_kit_id = tk.t_kit_id
    and     1 = 42
    
    union
    
    select	k.barcode, 
            k.kit_id,
			k.requisition_id, 
			k.outbound_tracking_id as tracking_id, 
            k.status as kit_status, 
            re.event_type, 
            re.event_desc, 
            re.event_summary, 
            'Outbound' as tracking_type,
            tk.name as kit_name
	from	ec_kits k left join ec_requisition_events re on k.requisition_id = re.requisition_id,
			ec_t_kits tk
	where  	k.outbound_tracking_id is not null
    and     length(k.outbound_tracking_id) >= 20
	and     lower(k.status) in ('submitted', 'transit', 'allocated', 'active')
	and     k.requisition_id is not null
	and     (re.tracking_type is null or lower(re.tracking_type = 'outbound'))
	and     lower(re.event_type) in ('tracking', 'info')
    and     (re.event_summary is null or lower(re.event_summary) not in ('delivered'))
	and     re.requisition_event_id = (select max(re2.requisition_event_id) from ec_requisition_events re2 where re2.requisition_id = k.requisition_id)
    and     k.t_kit_id = tk.t_kit_id
    and     1 = 42;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_getUspsTrackingNumbersForKitsWithoutOrders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_getUspsTrackingNumbersForKitsWithoutOrders`()
begin
	
    
	select	k.kit_id,
            k.barcode,
			k.requisition_id, 
			k.inbound_tracking_id as tracking_id, 
            k.status as kit_status,
            'Inbound' as tracking_type
	from	ec_partners p,
			ec_kits k left join ec_requisitions r on k.requisition_id = r.requisition_id
                      left join ec_kit_lab_rejection_map rm on k.kit_id = rm.kit_id
                      left join ec_kit_partner_error_map pe on k.kit_id = pe.kit_id
	where  	k.partner_id = p.partner_id
    and     k.inbound_tracking_id is not null
    and     length(k.inbound_tracking_id) >= 20
	and     lower(k.status) in ('allocated')
    and     r.submission_id is null
    and     rm.kit_id is null
    and     pe.kit_id is null
    and     upper(p.type_of) <> 'CONSUMER'
    and     1 + 1 = 3;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_hcp_assignHcpToReq` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_hcp_assignHcpToReq`(
	in_account_id bigint,
    in_state varchar(2)
)
begin
	
	

	declare n_telemedicine_physician_id bigint default null;
    
    
    create temporary table hcp_temporary_requsitions_ids engine=memory 
		select r.requisition_id
		  from accounts a, ec_requisitions r
		 where a.id = in_account_id
		   and a.user_id = r.user_id
		   and r.submission_id is null
		   and r.telemedicine_physician_id is null;
    
    
    
		select tpl.telemedicine_physician_id into n_telemedicine_physician_id
		 from telemedicine_physician_licenses tpl
		where tpl.state = in_state
	 order by rand() limit 1; 

	
    if n_telemedicine_physician_id is not null then
      update ec_requisitions set telemedicine_physician_id = n_telemedicine_physician_id
	   where requisition_id in ( select requisition_id from hcp_temporary_requsitions_ids );
    end if;
    
    drop temporary table if exists hcp_temporary_requsitions_ids;
      
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_hcp_recyclePatients` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_hcp_recyclePatients`()
begin
  
  

    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertIdentity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertIdentity`(
	IN in_account_id bigint(20),
    IN in_consented_at datetime,
    IN in_id_front_s3_key varchar(255),
    IN in_id_back_s3_key varchar(255),
    IN in_selfie_s3_key varchar(255),
    OUT out_identity_id bigint(20)
)
begin
	insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
		 values (in_account_id, in_consented_at, in_id_front_s3_key, in_id_back_s3_key, in_selfie_s3_key, curdate(), curdate());
         
	 SET out_identity_id = LAST_INSERT_ID();
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertOrUpdateBackPic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertOrUpdateBackPic`(
	IN in_account_id bigint(20),
    IN in_file_key varchar(255)
)
BEGIN
	DECLARE existing_id bigint(20) DEFAULT 0;

    SELECT id 
    INTO existing_id
    FROM identities
    WHERE account_id = in_account_id;

    IF existing_id > 0 THEN
		update identities set id_back_s3_key = in_file_key, updated_at = now() where id = existing_id;
        SELECT existing_id;
    ELSE
		insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
			values (in_account_id, now(), '', in_file_key, '', now(), now());
		SELECT LAST_INSERT_ID();
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertOrUpdateFrontPic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertOrUpdateFrontPic`(
	IN in_account_id bigint(20),
    IN in_file_key varchar(255)
)
BEGIN
	DECLARE existing_id bigint(20) DEFAULT 0;

    SELECT id 
    INTO existing_id
    FROM identities
    WHERE account_id = in_account_id;

    IF existing_id > 0 THEN
		update identities set id_front_s3_key = in_file_key, updated_at = now() where id = existing_id;
        SELECT existing_id;
    ELSE
		insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
			values (in_account_id, now(), in_file_key, '', '', now(), now());
		SELECT LAST_INSERT_ID();
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertOrUpdatePic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertOrUpdatePic`(
	in in_account_id bigint(20),
    in in_file_key varchar(255)
)
begin
	declare existing_id bigint(20) default 0;

    select id into existing_id from identities where account_id = in_account_id;

    if existing_id > 0 then
		if position('front' in in_file_key) > 1 then
			update identities set id_front_s3_key = in_file_key, updated_at = now() where id = existing_id;
		elseif position('back' in in_file_key) > 1 then
			update identities set id_back_s3_key = in_file_key, updated_at = now() where id = existing_id;
		else
			update identities set selfie_s3_key = in_file_key, updated_at = now() where id = existing_id;
        end if;
        
        
        update covid19_evaluations 
           set `status` = 3 
		 where account_id = in_account_id and `status` = 2 and identity_approved = 0;
         
         
         
		update covid19_rejection_reasons
           set resolved = 1 
		 where covid19_evaluation_id in (select id from covid19_evaluations where account_id = in_account_id)
		   and rejection_code in (0,1,2,3); 
        
        select existing_id;
    else
		if position('front' in in_file_key) > 1 then
			insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
				values (in_account_id, now(), in_file_key, '', '', now(), now());
		elseif position('back' in in_file_key) > 1 then
			insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
				values (in_account_id, now(), '', in_file_key, '', now(), now());
		else
			insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
				values (in_account_id, now(), '', '', in_file_key, now(), now());
        end if;
		select last_insert_id();
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertOrUpdateSelfiePic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertOrUpdateSelfiePic`(
	IN in_account_id bigint(20),
    IN in_file_key varchar(255)
)
BEGIN
	DECLARE existing_id bigint(20) DEFAULT 0;

    SELECT id 
    INTO existing_id
    FROM identities
    WHERE account_id = in_account_id;

    IF existing_id > 0 THEN
		update identities set selfie_s3_key = in_file_key, updated_at = now() where id = existing_id;
        SELECT existing_id;
    ELSE
		insert into identities (account_id, consented_at, id_front_s3_key, id_back_s3_key, selfie_s3_key, created_at, updated_at)
			values (in_account_id, now(), '', '', in_file_key, now(), now());
		SELECT LAST_INSERT_ID();
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertPartnerError` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertPartnerError`(in_barcode varchar(20), in_error_type varchar(255))
begin
  declare n_kit_id bigint(20) default null;
  
  
  select kit_id into n_kit_id from ec_kits k where k.barcode = in_barcode;
  
  insert into ec_kit_partner_error_map (kit_id, partner_error_id) 
  select n_kit_id, partner_error_id
  from   ec_partner_errors pe
  where  error_type = in_error_type;
  
  
  select error_response
  from   ec_partner_errors pe
  where  error_type = in_error_type;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertPortalUserVerify` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertPortalUserVerify`(
	in_user_id bigint(20),
    in_portrait_consent bool,
    in_portrait_status varchar(40),
    in_id_status varchar(40),
    in_identity varchar(100)
)
begin
	delete from ec_user_verify where user_id = in_user_id;

	insert into ec_user_verify (user_id, portrait_consent, portrait_status, id_status, identity, loa, verified)
		 values (in_user_id, in_portrait_consent, in_portrait_status, in_id_status, in_identity, 'LOA0', false);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_InsertSurvey` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_InsertSurvey`(
	in in_account_id bigint,
    in in_temperature varchar(20),
    in in_fever_above_range varchar(255),
    in in_feverish varchar(255),
    in in_chills varchar(255),
    in in_myalgia varchar(255),
    in in_rhinorrhea varchar(255),
    in in_sore_throat varchar(255),
    in in_cough varchar(255),
    in in_dyspnea varchar(255),
    in in_nausea_or_vomiting varchar(255),
    in in_headache varchar(255),
    in in_abdominal_pain varchar(255),
    in in_diarrea varchar(255),
    in in_loss_of_taste varchar(255),
    in in_loss_of_smell varchar(255),
    in in_others varchar(255),
    in in_sickness_start_date datetime,
    in in_sickness_end_date datetime
)
begin  
    declare dt_latest_date date default null;
    declare n_kit_id bigint default null;
    declare n_passport_product_id int default 2;
    
    
	select k.kit_id into n_kit_id
	  from ec_kits k, ec_requisitions r, accounts a
	 where k.requisition_id = r.requisition_id
	   and r.user_id = a.user_id
	   and a.id = in_account_id;
       
	
	select max(date(updated_at)) into dt_latest_date from ec_questions where kit_id = n_kit_id;
       
	
	 select pp.passport_product_id into n_passport_product_id
	   from  account_access_grants aag, partner_access_codes pac, ec_partners ep, passport_products pp, accounts a
	  where a.id = in_account_id
		and aag.account_id = a.id
		and aag.partner_access_code_id = pac.id
		and pac.partner_id = ep.partner_id
		and ep.passport_product_id = pp.passport_product_id;
    
    
	if (dt_latest_date < curdate() and n_passport_product_id in (1,3)) then		
		
    
		insert into ec_questions(t_question_id, kit_id, `group`, sub_group, question, required, hidden, gender, data_type_id)
		select tq.t_question_id, n_kit_id, tq.group, tq.sub_group, tq.question, tq.required, tq.hidden, tq.gender, tq.data_type_id
		  from ec_t_questions tq, ec_t_panels tp, ec_t_kits tk, ec_t_kits_t_panels_map kpm, ec_t_panels_t_questions_map pqm, ec_kits k
		 where k.kit_id = n_kit_id
		   and tk.t_kit_id = k.t_kit_id
		   and kpm.t_kit_id = tk.t_kit_id
		   and tp.t_panel_id = kpm.t_panel_id
		   and pqm.t_panel_id = tp.t_panel_id
		   and tq.t_question_id = pqm.t_question_id;
        
        select curdate() into dt_latest_date; 
	end if;
       
	update ec_questions q set q.response = in_temperature, updated_at = now()  
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question = 'Temperature';    
       
	update ec_questions q set q.response = in_fever_above_range, updated_at = now()  
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Fever >%';    
    
    update ec_questions q set q.response = in_feverish, updated_at = now() 			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Subjective fever%';
    
    update ec_questions q set q.response = in_chills, updated_at = now() 			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Chills%';
    
    update ec_questions q set q.response = in_myalgia, updated_at = now()			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like '%myalgia%';
    
    update ec_questions q set q.response = in_rhinorrhea, updated_at = now() 		
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like '%rhinorrhea%';
    
    update ec_questions q set q.response = in_sore_throat, updated_at = now() 		 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Sore throat';
    
    update ec_questions q set q.response = in_cough, updated_at = now() 			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Cough%';
    
    update ec_questions q set q.response = in_dyspnea, updated_at = now() 			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like '%dyspnea%';
    
    update ec_questions q set q.response = in_nausea_or_vomiting, updated_at = now() 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Nausea%';
    
    update ec_questions q set q.response = in_headache, updated_at = now() 			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Headache';
    
    update ec_questions q set q.response = in_abdominal_pain, updated_at = now() 	 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Abdominal pain';
    
    update ec_questions q set q.response = in_diarrea, updated_at = now() 			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Diarrhea%';
    
    update ec_questions q set q.response = in_loss_of_taste, updated_at = now() 	 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Loss of taste%';
    
    update ec_questions q set q.response = in_loss_of_smell, updated_at = now()	 	 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'Loss of smell%';
    
    update ec_questions q set q.response = in_others, updated_at = now() 			 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like '%other symptoms%';
    
    update ec_questions q set q.response = in_sickness_start_date, updated_at = now() 
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'When did you start feeling sick%';
    
    update ec_questions q set q.response = in_sickness_end_date, updated_at = now()   
    where date(updated_at) = dt_latest_date and q.kit_id = n_kit_id and lower(q.group) like 'covid-19%' and q.question like 'When was the last day you felt%';
    
    
    if (n_passport_product_id in (1,3)) then		
		call ec_setDailyCheckupStatus(in_account_id);
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertTestResult` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertTestResult`(
    in in_test_id bigint,
    in in_file_key varchar(255)
)
begin	
	declare n_account_id bigint default null;
    
    select account_id into n_account_id from covid19_tests where id = in_test_id;
	
    
	update covid19_evaluations 
	   set `status` = 3 
	 where account_id = n_account_id and `status` = 2 and lab_review_approved = 0;
     
     
	 
	update covid19_rejection_reasons
	   set resolved = 1 
	 where covid19_evaluation_id in (select id from covid19_evaluations where account_id = n_account_id)
	   and rejection_code in (5,6,7,8);
     
	insert into covid19_test_results (covid19_test_id, persisted_s3_key, uploaded, created_at, updated_at)
		values (in_test_id, in_file_key, 1, now(), now());
        
	select last_insert_id();
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertTrackingEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertTrackingEvent`(in_event_desc varchar(255), in_event_summary varchar(45), in_requisition_id bigint(20), in_tracking_type varchar(8))
begin   
	insert into ec_requisition_events (requisition_id, event_type, event_desc, event_summary, tracking_type, created_at, updated_at)
	values (in_requisition_id, 'Tracking', in_event_desc, in_event_summary, in_tracking_type, now(), now());
    
    
    
    if lower(trim(in_event_summary)) = 'shipped' then
		update ec_kits set status = 'TRANSIT' where requisition_id = in_requisition_id;
	elseif lower(trim(in_event_summary)) = 'delivered' then
		update ec_kits set status = 'PROCESSING' where requisition_id = in_requisition_id;
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_insertUserMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_insertUserMessage`(	
	in_user_id bigint(20), in_type_of varchar(255), in_source varchar(255), in_subject varchar(255), in_body text, in_delivered tinyint(1)
)
begin
	insert into ec_user_messages(user_id, type_of, `source`, `subject`, body, delivered, created_at, created_on)
    values (in_user_id, in_type_of, in_source, in_subject, in_body, in_delivered, now(), now());
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_modifyUserFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_modifyUserFromPartner`(
	in_email varchar(255), 
	in_first_name varchar(255), 
    in_last_name varchar(255), 
    in_address1 varchar(255), 
    in_address2 varchar(255),
	in_city varchar(255), 
    in_state varchar(255), 
    in_zip varchar(10), 
    in_phone varchar(15), 
    in_mobile varchar(15),
    in_dob varchar(10),
    in_gender varchar(1),
    in_height_in mediumint(9),
    in_weight_lbs mediumint(9),
    in_race varchar(20),
    in_partner_user_id varchar(255)
    
)
begin
	declare n_user_id int(11) default null;
    
    select user_id into n_user_id from ec_users_partners_map where partner_user_id = in_partner_user_id;
    
    if (n_user_id is not null) then
		
		update ec_users set 
			email = in_email, 
			first_name = in_first_name, 
			last_name = in_last_name, 
			address1 = in_address1, 
			address2 = in_address1, 
			city = in_city, 
			state = in_state, 
			zip = in_zip, 
			phone = in_phone
		where user_id = n_user_id;
    
		
		update ec_user_demographics set
			birthdate = str_to_date(in_dob,  '%m/%d/%Y %T'), 
			gender = in_gender, 
			height_in = in_height_in, 
			weight_in = in_weight_in, 
			updated_at = now()
		where user_id = n_user_id;
	end if;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_postOrderEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_postOrderEvent`(in_requisition_id bigint(20), in_status varchar(45), in_submission_id varchar(20))
begin
	

    declare n_requires_manifest int(1) default 0;
	declare n_requisition_id int(11) default in_requisition_id;
  
	if (n_requisition_id is null or n_requisition_id < 1) then
		select requisition_id into n_requisition_id from ec_requisitions where submission_id = in_submission_id;
	end if;

	if (in_submission_id is not null) then         
		
		update ec_requisitions set updated_at = now(), submission_id = in_submission_id where requisition_id = n_requisition_id;
        
        if (lower(in_status) = 'pending') then
           select api_requiresManifestCredentials(n_requisition_id) into n_requires_manifest;
           if (n_requires_manifest = 1) then
		     
             insert into ec_requisition_manifests (requisition_id, created_at) values (n_requisition_id, now());
           end if;
        end if;
        
	end if;
	  
	insert into ec_requisition_events (requisition_id, event_type, event_desc, created_at, updated_at)
    values (n_requisition_id, 'INFO', lower(in_status), now(), now());
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_postPwnPhysician` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_postPwnPhysician`(
	in_requisition_id int(11), 
  in_physician_license varchar(45), 
	in_physician_name varchar(45), 
	in_physician_npi int(10)
)
begin
	declare n_pwn_physician_id int(11) default null;

    
    
   
	select p.pwn_physician_id into n_pwn_physician_id 
	from   ec_pwn_physicians p
	where  p.npi = in_physician_npi 
	and    p.license = in_physician_license;

	if (n_pwn_physician_id is null) then

		
		insert into ec_pwn_physicians (license, name, npi, created_at, updated_at)
		values (in_physician_license, in_physician_name, in_physician_npi, now(), now());  
      
		select last_insert_id() into n_pwn_physician_id;
    end if;

    
    insert into ec_pwn_physicians_reqs_map 
    values (in_requisition_id, n_pwn_physician_id);
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_rejectResults` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_rejectResults`(
	in_comments text, 
    in_barcode varchar(20), 
    in_pdf mediumblob,
    in_rejected_reason varchar(255),
    in_lab_rejection_id bigint(20)
)
begin
	

	declare n_kit_id bigint(20) default -1;
	declare n_requisition_id bigint(20) default -1;
 
    
    select kit_id into n_kit_id from ec_kits k where k.barcode = in_barcode;
    
    
	
	
    if in_lab_rejection_id is not null then
		insert into ec_kit_lab_rejection_map (kit_id, lab_rejection_id) values (n_kit_id, in_lab_rejection_id);
    end if;
    
    
    select requisition_id into n_requisition_id from ec_kits k where k.kit_id = n_kit_id;
    
    if n_requisition_id is not null and n_requisition_id > 0 then
		
		
        
	   
       insert into ec_requisition_events (requisition_id, event_type, event_summary, event_desc, created_at, updated_at) 
       values (n_requisition_id, 'ORDER', 'REJECTED', in_rejected_reason, now(), now());
    end if;
    
    
	update ec_kits set status = 'REJECTED', updated_at = now() where kit_id = n_kit_id;
    
    if in_pdf is not null then
       insert into ec_attachments (attachment, object_type, object_id, created_at, updated_at)
       values (in_pdf, 'ec_requisitions', n_requisition_id, now(), now());
    end if; 
  
    if in_comments is not null and length(trim(in_comments)) > 0 then
       insert into ec_comments (comment, object_type, object_id, created_at, updated_at)
       values (in_comments, 'ec_requisitions', n_requisition_id, now(), now());
    end if; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_runAllChordDiagrams` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_runAllChordDiagrams`()
begin
	
	declare n_finished integer default 0;
	declare n_kit_id bigint(20) default 0;
	 
	declare kits_cursor CURSOR FOR
		select kit_id
		from   ec_kits 
		where  status = 'COMPLETED';
	 
	 declare continue handler
			for not found set n_finished = 1;
            
	 open kits_cursor;
	 process_kits: loop
		 fetch kits_cursor into n_kit_id;
		 if n_finished = 1 then leave process_kits; end if;
		 call api_chordDiagram(n_kit_id);
	 end loop process_kits;
	 
	 close kits_cursor;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_runAllReportAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_runAllReportAnalytics`()
begin
	
	declare n_finished integer default 0;
	declare n_kit_id bigint(20) default 0;
	 
	declare kits_cursor CURSOR FOR
		select kit_id
		from   ec_kits 
		where  status = 'COMPLETED';
	 
	 declare continue handler
			for not found set n_finished = 1;
            
	 open kits_cursor;
	 process_kits: loop
		 fetch kits_cursor into n_kit_id;
		 if n_finished = 1 then leave process_kits; end if;
		 call api_runReportAnalytics(n_kit_id);
	 end loop process_kits;
	 
	 close kits_cursor;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_runCortisol2xAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_runCortisol2xAnalytics`(in_kit_id bigint(20), in_t_report_analytics_id bigint(20))
exit_procedure: 
begin
	declare n_cortisol_count integer default 0;
	declare n_zscore1 decimal (10,3) default 0;
	declare n_zscore2 decimal (10,3) default 0;
    
	
    select count(test_name) into n_cortisol_count from ec_tests where kit_id = in_kit_id and lower(test_name) like '%cortisol%';
	if (n_cortisol_count <> 2) then leave exit_procedure; end if;

    
	select sum(case when sequence = 1 then z_score else 0 end), sum(case when sequence = 2 then z_score else 0 end) into n_zscore1, n_zscore2
	from 	ec_tests 
	where 	kit_id = in_kit_id 
	and     lower(test_name) like '%cortisol%';
   
    
    insert into ec_report_analytics (kit_id, t_report_analytic_id, seq, summary, item_text, created_at, updated_at)
	select in_kit_id, t_report_id, seq, summary, item_text, now(), now()
      from ec_t_report_analytics_items 
     where t_report_analytic_id = 2 
	   and seq = (case when n_zscore1 >   1.0 and n_zscore1 >   1.0 then 1 
					when n_zscore1 <  -1.0 and n_zscore1 <  -1.0 then 2 
					when n_zscore1 >= -1.0 and n_zscore1 <  -1.0 then 4 
					when n_zscore1 >   1.0 and n_zscore1 >= -1.0 then 5 
					when n_zscore1 >= -1.0 and n_zscore1 >   1.0 then 6 
					when n_zscore1 <  -1.0 and n_zscore1 >= -1.0 then 7 
					else 3
				end);
		
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_runFeatureAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_runFeatureAnalytics`(in_kit_id bigint(20), in_t_report_analytic_id bigint(20), in_analyte varchar(20))
exit_procedure: 
begin
	declare n_count integer default 0;
	declare n_report_analytics_item_id integer default 0;
	declare n_stddev decimal;
    declare n_seq integer;
    declare v_summary varchar(45);
    declare v_item_text text;
    
	
    select count(test_name) into n_count from ec_tests where kit_id = in_kit_id and lower(test_name) like in_analyte; 
	if (n_count < 3) then leave exit_procedure; end if;

	select in_analyte, in_kit_id, in_t_report_analytic_id;

    
    
    

		select                               
		  id, sum(sd) as stddev_model_sample, itemseq, summary, item_text into n_report_analytics_item_id, n_stddev, n_seq, v_summary, v_item_text
		from 			
		(
			  select f.t_report_analytic_item_id as id, f.model_number, f.seq, api_stddev(multiplier, greatest(least(t.z_score, 1.25), -1.25)) as sd,
                     i.seq as itemseq, i.summary, i.item_text
			  from   ec_t_report_analytic_features f, ec_tests t, ec_t_report_analytic_items i, ec_kits k, ec_partners p
			  where  t.kit_id     = in_kit_id
              and    t.kit_id     = k.kit_id
              and    k.partner_id = p.partner_id
              and    t.sequence   = f.seq
              and    (i.partner_type_of is null or i.partner_type_of = p.type_of)			  
			  and    f.t_report_analytic_item_id = i.t_report_analytic_item_id
			  and    i.t_report_analytic_id      = in_t_report_analytic_id
			  and 	lower(t.test_name) like in_analyte 
		) t2
		group by id, model_number
        order by stddev_model_sample asc limit 1;

    insert into ec_report_analytics (kit_id, t_report_analytic_id, seq, summary, item_text, created_at, updated_at) 
    values (in_kit_id, in_t_report_analytic_id, n_seq, v_summary, v_item_text, now(), now());
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_runHormone1xAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_runHormone1xAnalytics`(in_kit_id bigint(20), in_t_report_analytics_id bigint(20), in_report_type varchar(45))
exit_procedure:
begin
  declare n_hormone_count integer default 0;
  declare n_min decimal (10,3) default 0;
  declare n_max decimal (10,3) default 0;
  declare n_result decimal (10,3) default 0;
  
  
  select count(test_name),     max(rr_min), max(rr_max), max( cast(trim('>' from trim('<' from result)) as decimal(10,3)))
		 into n_hormone_count, n_min,       n_max,       n_result 
  from ec_tests where kit_id = in_kit_id and lower(test_name) like concat('%',SUBSTRING_INDEX(lower(in_report_type), '-', 1),'%');
  if (n_hormone_count <> 1) then leave exit_procedure; end if;
  
  
  insert into ec_report_analytics (kit_id, t_report_analytic_id, seq, summary, item_text, created_at, updated_at)
  select in_kit_id, ri.t_report_analytic_id, ri.seq, ri.summary, ri.item_text, now(), now()
    from ec_t_report_analytic_items ri, ec_t_report_analytics ra
   where ri.t_report_analytic_id = in_t_report_analytics_id 
	 and ri.t_report_analytic_id = ra.t_report_analytic_id
	 and ri.seq = (case when n_result < n_min then 1 when n_result > n_max then 3 else 2 end);
	
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_runMelatonin6xAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_runMelatonin6xAnalytics`(in_kit_id bigint(20), in_t_report_analytics_id bigint(20))
exit_procedure: 
begin
	declare n_melatonin_count integer default 0;
    declare n_avg decimal (10,3) default null;
	declare n_stdev decimal (10,3) default null;
    declare n_dlmo decimal (10,3); 
    declare n_max_wake_melatonin decimal (10,3) default null;
    declare n_bedtime_melatonin decimal (10,3) default null;

    
    select count(test_name) into n_melatonin_count from ec_tests where kit_id = in_kit_id and lower(test_name) like '%melatonin%';
	if (n_melatonin_count < 6) then leave exit_procedure; end if;
    
    
    select 	avg(result), stddev_samp(result), max(result) into n_avg, n_stdev, n_max_wake_melatonin
    from (
    select  cast(trim('>' from trim('<' from result)) as decimal(10,3)) as result
    from 	ec_tests
    where 	kit_id = in_kit_id 
    and 	lower(test_name) like '%melatonin%'
    order by collected_at, sequence
    limit 3) t;
    
    
    if (n_avg is null or n_stdev is null) then leave exit_procedure; end if;
    
    
    set n_dlmo = n_avg + n_stdev * 2.0;
    
    
    select 	trim('>' from trim('<' from result)) into n_bedtime_melatonin
    from 	ec_tests
    where 	kit_id = in_kit_id 
    and 	lower(test_name) like '%melatonin%'
    order by collected_at, sequence
    limit 4, 1; 
    
    
    insert into ec_report_analytics (t_report_analytic_id, kit_id, seq, summary, item_text, created_at, updated_at) 
    select t_report_analytic_id, in_kit_id, i.seq, i.summary, i.item_text, now(), now()
	  from ec_t_report_analytic_items i
	 where t_report_analytic_id = in_t_report_analytics_id 
	   and seq = (case when n_bedtime_melatonin > n_dlmo then 1 when n_bedtime_melatonin <= n_dlmo and n_bedtime_melatonin <= n_max_wake_melatonin then 2 else 3 end); 

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_runReportAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_runReportAnalytics`(in_kit_id bigint(20))
begin
	declare n_finished integer default 0;
    declare v_gender varchar(1) default null;
    declare v_report_type varchar(45) default '';
	declare n_analytics_id bigint(20) default 0;
	 
	
    
    
	declare ids_cursor CURSOR FOR
		select max(t_report_analytic_id), max(report_type)
        from (
				select distinct(pram.t_report_analytic_id), tpa.report_type, SUBSTRING_INDEX(report_type, '-', 1) analyte
				from   ec_kits k, ec_panels p, ec_t_panel_t_report_analytic_map pram, ec_t_report_analytics tpa
				where  p.kit_id = k.kit_id
				and    p.t_panel_id = pram.t_panel_id
				and    tpa.t_report_analytic_id = pram.t_report_analytic_id
				and    k.kit_id = in_kit_id
				and    ( tpa.gender is null or tpa.gender = v_gender)
				order by analyte, t_report_analytic_id desc
            ) t
		group by analyte;
		 
	 declare continue handler
			for not found set n_finished = 1;
	 
     
     SET SQL_SAFE_UPDATES = 0;
     delete from ec_report_analytics where kit_id = in_kit_id;
     
     
	 select gender into v_gender
	 from   ec_user_demographics ud, ec_requisitions r, ec_kits k
	 where  ud.user_id = r.user_id
	 and    r.requisition_id = k.requisition_id
	 and    k.kit_id = in_kit_id;
		
	 open ids_cursor;
	 
	 process_analytics: loop
	 
		 fetch ids_cursor into n_analytics_id, v_report_type;
		 
		 if n_finished = 1 then leave process_analytics; end if;
		 
		 
		 
         
         
         case 
              when v_report_type = 'Cortisol-1x'   then call api_runHormone1xAnalytics(in_kit_id, n_analytics_id, v_report_type);
			  when v_report_type = 'DHEA-S'        then call api_runHormone1xAnalytics(in_kit_id, n_analytics_id, v_report_type);
              when v_report_type = 'Estradiol'     then call api_runHormone1xAnalytics(in_kit_id, n_analytics_id, v_report_type);
              when v_report_type = 'Progesterone'  then call api_runHormone1xAnalytics(in_kit_id, n_analytics_id, v_report_type);
              when v_report_type = 'Testosterone'  then call api_runHormone1xAnalytics(in_kit_id, n_analytics_id, v_report_type);
              when v_report_type = 'Cortisol-2x'   then call api_runCortisol2xAnalytics(in_kit_id, n_analytics_id);
              when v_report_type = 'Cortisol-4x'   then call api_runFeatureAnalytics(in_kit_id, n_analytics_id, '%cortisol%');
              when v_report_type = 'Melatonin-3x'  then call api_runFeatureAnalytics(in_kit_id, n_analytics_id, '%melatonin%');
              when v_report_type = 'Melatonin-4x'  then call api_runFeatureAnalytics(in_kit_id, n_analytics_id, '%melatonin%');
              when v_report_type = 'Melatonin-6x'  then call api_runMelatonin6xAnalytics(in_kit_id, n_analytics_id);
              else begin end;
		 end case;
         
	 end loop process_analytics;
	 
	 close ids_cursor;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_saveApiUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_saveApiUser`(
	in_username varchar(40), 
    in_password_hash varbinary(64),
    in_password_salt varbinary(128)
)
begin
	insert into api_users
		(username, ec_partners_username, password_salt, password_hash, created_at, updated_at)
	values
		(in_username, in_username, in_password_salt, in_password_hash, utc_timestamp(), utc_timestamp());
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_savePortalUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_savePortalUser`(
	encryptedPassword varbinary(64),
    email varchar(255),
    accessCodeId int
)
begin
	declare n_kit_id      bigint(20) default null;
    declare n_partner_id  bigint(20) default null;
    declare n_req_id      bigint(20) default null;
    declare n_t_kit_id    bigint(20) default null;
    declare n_user_id     bigint(20) default null;
    declare v_barcode     varchar(20) default null;
    declare n_account_id  bigint(20) default null;
        
    
    
    
    insert into ec_users (email, created_at, updated_at) values (email, utc_timestamp(), utc_timestamp());
    select last_insert_id() into n_user_id;
    insert into ec_user_demographics (user_id) values (n_user_id);
    
    select partner_id into n_partner_id from partner_access_codes pac where pac.id = accessCodeId;
    
    select t_kit_id
      into n_t_kit_id
      from passport_products pp, ec_partners p
     where p.partner_id = n_partner_id 
       and p.passport_product_id = pp.passport_product_id;

    call ec_create_kit(n_t_kit_id, n_partner_id, null, n_kit_id);
    select barcode into v_barcode from ec_kits where kit_id = n_kit_id;
    
    call ec_create_requisition(n_user_id, v_barcode, n_req_id);
    
    
    
    
    
	insert into accounts
		(user_id, agreed_to_age_at, agreed_to_tos_at, email, unconfirmed_email, encrypted_password, created_at, updated_at)
	values
		(n_user_id, utc_timestamp(), utc_timestamp(), email, unconfirmed_email, encryptedPassword, utc_timestamp(), utc_timestamp());
	
    select last_insert_id() into n_account_id;
    
	insert into account_access_grants (account_id, partner_access_code_id, created_at, updated_at) values (n_account_id, accessCodeId, utc_timestamp(), utc_timestamp());
    insert into account_demographics (account_id, created_at, updated_at) values (n_account_id, utc_timestamp(), utc_timestamp());
    
    select n_account_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_saveRequisitionPdf` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_saveRequisitionPdf`(
	in_requisition_id bigint(20),
    in_pdf mediumblob
)
begin
	insert into ec_attachments (attachment, object_type, object_id, created_at, updated_at)
    values (in_pdf, 'requisition-pdf', n_requisition_id, now(), now());
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_saveResultData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_saveResultData`(
	in_kit_id int(11), 
    in_test_code varchar(45), 
    in_test_name varchar(45), 
    in_result_date varchar(20),
    in_value_type varchar(2), 
    in_value varchar(45), 
    in_units varchar(45), 
    in_ref_range varchar(45), 
    in_abnormal_flags varchar(45),
    in_result_status varchar(45), 
    in_sequence int(3),
    in_result_comments text,
    in_collected_at varchar(20)
)
begin
     declare n_result decimal (10,3);
     declare n_rr_min decimal (10,3);
     declare n_rr_max decimal (10,3);
     declare n_rr_avg decimal (10,3);
     declare n_rr_stdev decimal (10,3);
     declare n_z_score decimal (6,3);

	 declare n_t_test_id bigint(20) default null;
     declare v_testname varchar(50) default null;
     
     declare v_abnormal_flag varchar(1) default 'N';
     
     
     
     if in_ref_range like '%>%' then  
		set n_rr_min = SUBSTRING_INDEX(in_ref_range, '>', 1);
		set n_rr_max = SUBSTRING_INDEX(in_ref_range, '>', -1);
     elseif in_ref_range like '%<%' then 
		set n_rr_min = SUBSTRING_INDEX(in_ref_range, '<', 1);
		set n_rr_max = SUBSTRING_INDEX(in_ref_range, '<', -1);
     else
		set n_rr_min = SUBSTRING_INDEX(in_ref_range, '-', 1);
		set n_rr_max = SUBSTRING_INDEX(in_ref_range, '-', -1);
     end if;
     
     set n_rr_avg = (n_rr_max + n_rr_min) / 2 ;
     set n_rr_stdev = sqrt(( pow(n_rr_max - n_rr_avg,2) + pow(n_rr_avg - n_rr_min,2)) / 2); 
     set n_result = trim('>' from trim('<' from in_value));
     set n_z_score = (n_result - n_rr_avg) / n_rr_stdev;
     
     
	 
     
     if n_result > n_rr_max then 
		set v_abnormal_flag = 'H';
	 elseif n_result < n_rr_min then 
       set v_abnormal_flag = 'L'; 
	 end if;
     
     
     select  coalesce(tt.t_test_id, 0) , tt.test into n_t_test_id, v_testname
	 from 	 ec_kits k, ec_panels p, ec_t_panels tp, ec_t_tests tt, ec_t_panels_t_tests_map ptm
	 where 	 k.kit_id     = in_kit_id
	 and     k.kit_id     = p.kit_id
	 and     tp.t_panel_id  = p.t_panel_id
	 and     ptm.t_panel_id = tp.t_panel_id
	 and     ptm.t_test_id  = tt.t_test_id
	 and     ( (tt.sequence is null and in_sequence = 1) or tt.sequence = in_sequence)
     and     lower(substring_index(tt.test, ' ', 1)) = lower(substring_index(in_test_name, ' ', 1))
     order by length(tt.test) desc, tt.test desc
     limit 1;

	 
     if in_test_name = substring_index(in_test_name, ' ', 1) and in_test_name <> v_testname then
		set in_test_name = v_testname;
     end if;
    
     if n_t_test_id is not null then
		 insert into ec_tests 
		 (
				t_test_id, 
				kit_id, 
				test_code,
				test_name, 
				result, 
				data_type_id, 
				units, 
				ref_range, 
				rr_min,
				rr_max,
				rr_avg,
				rr_stdev,
				z_score,
				matrix, 
				created_at, 
				updated_at, 
				abnormal_flags, 
				result_status, 
				result_date,
				sequence,
				collected_at,
				sort_order
		) 
		values 
		(
				n_t_test_id,
				in_kit_id, 
				in_test_code,
				in_test_name, 
				in_value, 
				null, 
				in_units, 
				in_ref_range,  
				n_rr_min,
				n_rr_max,
				n_rr_avg,
				n_rr_stdev,
				n_z_score,
				null, 
				now(), 
				now(),
				v_abnormal_flag, 
				in_result_status, 
				str_to_date(in_result_date,  '%m/%d/%Y %T'),
				in_sequence,
				case when in_collected_at is not null then str_to_date(in_collected_at,  '%m/%d/%Y %T') else null end,
				api_TestSortOrder(in_kit_id, n_t_test_id)
		);
        
        if v_abnormal_flag <> 'N' then
			
            update ec_kits k set k.flagged_status = 'FLAGGED' where k.kit_id = in_kit_id;
        end if;
        
	else
		insert into ec_tests_extra
		 (
				t_test_id, 
				kit_id, 
				test_code,
				test_name, 
				result, 
				data_type_id, 
				units, 
				ref_range, 
				rr_min,
				rr_max,
				rr_avg,
				rr_stdev,
				z_score,
				matrix, 
				created_at, 
				updated_at, 
				abnormal_flags, 
				result_status, 
				result_date,
				sequence,
				collected_at,
				sort_order
		) 
		values 
		(
				0,
				in_kit_id, 
				in_test_code,
				in_test_name, 
				in_value, 
				null, 
				in_units, 
				in_ref_range,  
				n_rr_min,
				n_rr_max,
				n_rr_avg,
				n_rr_stdev,
				n_z_score,
				null, 
				now(), 
				now(),
				v_abnormal_flag, 
				in_result_status, 
				str_to_date(in_result_date,  '%m/%d/%Y %T'),
				in_sequence,
				case when in_collected_at is not null then str_to_date(in_collected_at,  '%m/%d/%Y %T') else null end,
				0
		);
	end if;
             
	if in_result_comments is not null and length(trim(in_result_comments)) > 0 then
       insert into ec_comments (comment, object_type, object_id, created_at, updated_at)
       values (in_result_comments, 'ec_tests', (select requisition_id from ec_kits where kit_id=in_kit_id), now(), now());
    end if; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_saveResultsReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_saveResultsReport`(
	in_comments text, 
    in_barcode varchar(20), 
    in_report_status varchar(255), 
    in_pdf mediumblob, 
    out out_kit_id bigint(20)
)
begin
	declare n_requisition_id  bigint(20)  default -1;
    declare out_partner_type_of varchar(20) default 'CLINIC';
    
    
    
    select k.kit_id, p.type_of into out_kit_id, out_partner_type_of
      from ec_kits k, ec_partners p 
	 where k.barcode    = in_barcode
       and k.partner_id = p.partner_id;
    
    
    select requisition_id into n_requisition_id from ec_kits k where k.kit_id = out_kit_id;
    
    
    update ec_requisitions set updated_at = now() where requisition_id = n_requisition_id;
    
    
    
    if (in_report_status = 'Review') then
		update ec_kits set status = 'REVIEW', updated_at = now() where kit_id = out_kit_id;
    else
		update ec_kits set status = 'COMPLETED', updated_at = now() where kit_id = out_kit_id;
        
        
        if (out_partner_type_of = 'CONSUMER') then
			update ec_kits set release_status = 'RELEASED', updated_at = now() where kit_id = out_kit_id;
        end if;        
    end if;
    
	

	delete from ec_tests where kit_id = out_kit_id;
    delete from ec_tests_extra where kit_id = out_kit_id;
    
    if in_report_status is not null and length(trim(in_report_status)) > 0 then
       insert into ec_requisition_events (requisition_id, event_type, event_desc, created_at, updated_at) 
       values (n_requisition_id, 'ORDER', in_report_status, now(), now());
    end if; 
  
    if in_pdf is not null then
       insert into ec_attachments (attachment, object_type, object_id, created_at, updated_at)
       values (in_pdf, 'ec_requisitions', n_requisition_id, now(), now());
    end if; 
  
    if in_comments is not null and length(trim(in_comments)) > 0 then
       insert into ec_comments (comment, object_type, object_id, created_at, updated_at)
       values (in_comments, 'ec_requisitions', n_requisition_id, now(), now());
    end if; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateAccountDemographics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updateAccountDemographics`(
	in_account_id bigint,
	in_name varchar(255),
	in_state varchar(2),
	in_gender varchar(6),
	in_dob date,
	in_phone varchar(30),
	in_address varchar(255)
)
begin
	declare n_user_id bigint default null;

	update 
		account_demographics
	set
		full_legal_name = in_name, 
		state_of_residence = in_state, 
		gender = in_gender, 
		date_of_birth = in_dob, 
		phone_number = in_phone, 
		address = in_address,
		updated_at = utc_timestamp()
	where 
		account_id = in_account_id;

	select user_id into n_user_id from accounts where id = in_account_id;

	update
		ec_users
	set
		address1 = in_address,
		state = in_state,
		phone = in_phone,
		first_name = in_name,
		updated_at = utc_timestamp()
	where
		user_id = n_user_id;
		
	call api_hcp_assignHcpToReq(in_account_id, in_state);
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateCoachCommentsStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updateCoachCommentsStatus`(in_comments_id bigint(20), in_status varchar(45))
begin
   update ec_coach_comments set status = upper(in_status) where coach_comment_id = in_comments_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateCoachSessionStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updateCoachSessionStatus`(in_session_id bigint(20), in_status varchar(45))
begin
   update ec_coach_sessions set status = upper(in_status) where coach_session_id = in_session_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateLabData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updateLabData`(in_lab_data_id bigint(20), in_status varchar(45))
begin
   update ec_lab_data set status = upper(in_status), updated_at = now() where lab_data_id = in_lab_data_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updateMessage`(
	in_account_id bigint, 
    in_message_id bigint
)
begin
  update covid19_messages 
     set resolved = 1, updated_at = now() 
   where covid19_message_id = in_message_id
     and account_id = in_account_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updatePortalUserPassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updatePortalUserPassword`(
	in_email varchar(255),
    in_encrypted_password varbinary(64)
)
BEGIN
	update accounts set encrypted_password = in_encrypted_password where email = in_email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updatePortalUserVerifyConsent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updatePortalUserVerifyConsent`(
	in_user_id bigint(20),
    in_consent_id bigint(20),
    in_identity varchar(40)
)
begin
	update ec_user_verify 
       set portrait_consent = 1, updated_at = now() 
     where user_id  = in_user_id 
       and identity = in_identity;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateTracking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updateTracking`(in_tracking_number varchar(100), in_status varchar(255))
begin
  
   declare n_requisition_id int(11) default null;
  
   select  k.requisition_id into n_requisition_id 
     from  ec_kits k
    where  k.inbound_tracking_id  = in_tracking_number
       or  k.outbound_tracking_id = in_tracking_number;
   
   if n_requisition_id is not null then
		insert into ec_requisition_events (requisition_id, event_type, event_desc, created_at, updated_at)
		values (n_requisition_id, 'TRACKING', lower(in_status), now(), now());
   end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateUserFromPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_updateUserFromPartner`(
	in_email varchar(255), 
    in_first_name varchar(255), 
    in_last_name varchar(255), 
    in_address1 varchar(255), 
    in_address2 varchar(255),
	in_city varchar(255), 
    in_state varchar(255), 
    in_zip varchar(10), 
    in_phone varchar(15), 
    in_mobile varchar(15),
    in_dob varchar(10),
    in_gender varchar(1),
    in_height_in mediumint(9),
    in_weight_lbs mediumint(9),
    in_race varchar(20),
    in_partner_user_id varchar(255),
    in_partner_name varchar(255),
    in_barcode varchar(20)
)
begin
	declare n_user_id int(11) default null;
    declare n_partner_id bigint(20) default null;
    declare n_out_req bigint(20);
    
    
    select partner_id into n_partner_id
      from ec_partners p
	 where p.name = in_partner_name;
    
    
    select user_id into n_user_id
      from ec_users_partners_map upm
	 where upm.partner_user_id = in_partner_user_id
       and upm.partner_id = n_partner_id;
        
    
	update ec_users 
       set email = in_email, first_name = in_first_name, last_name = in_last_name, address1 = in_address1, address2 = in_address2, 
		   city = in_city, state = in_state, zip = in_zip, phone = in_phone, mobile = in_mobile, updated_at = now()
     where user_id = n_user_id;					 
    
    
    update ec_user_demographics 
       set birthdate = str_to_date(in_dob,  '%m/%d/%Y'), gender = in_gender, height_in = in_height_in, weight_lbs = in_weight_lbs, updated_at = now()
	 where user_id = n_user_id;
     
    
    if (in_barcode is not null and length(in_barcode) > 0) then
		call ec_create_requisition(n_user_id, in_barcode, n_out_req);
        update ec_kits set status = 'SUBMITTED' where barcode = in_barcode;
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_updateValidationEmailInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_updateValidationEmailInfo`(
id long,
token varchar(255)
)
BEGIN
	update accounts ac set ac.confirmation_token=token, ac.confirmation_sent_at=utc_timestamp()
    where ac.id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_validateEmailStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `api_validateEmailStatus`(
userId long
)
BEGIN
	update accounts set confirmed_at=utc_timestamp()
    where id=userId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `api_validatePartnerUserId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `api_validatePartnerUserId`(in_partner_user_id varchar(255), in_partner_name varchar(255))
begin
	select  pm.partner_user_id
      from  ec_users_partners_map pm, ec_partners p
	 where  pm.partner_user_id = in_partner_user_id
       and  pm.partner_id = p.partner_id
       and  p.name = in_partner_name;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_accept_policy_terms` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_accept_policy_terms`(IN n_user_id BIGINT(20))
BEGIN
  delete 
    from ec_policy_manager_user_terms
   where user_id = n_user_id;
   
  insert
    into ec_policy_manager_user_terms
		(policy_manager_term_id,
	     user_id,
		 state)
 (select policy_manager_term_id,
         n_user_id,
		 'accepted'
    from ec_policy_manager_terms
   where state = 'published');
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_add_questions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_add_questions`(in i_kit_id bigint, in i_tpanel_id bigint)
begin
	

    insert
      into ec_questions(
           t_question_id,
           kit_id,
           `group`,
           sub_group,
           question,
           required,
           hidden,
           gender,
           data_type_id)
    select tq.t_question_id,
           i_kit_id,
           tq.group,
           tq.sub_group,
           tq.question,
           tq.required,
           tq.hidden,
           tq.gender,
           tq.data_type_id
      from ec_t_questions tq,
           ec_t_panels tp,
           ec_t_kits tk,
           ec_t_kits_t_panels_map kpm,
           ec_t_panels_t_questions_map pqm,
           ec_kits k
     where k.kit_id = i_kit_id
       and tk.t_kit_id = k.t_kit_id
       and kpm.t_kit_id = tk.t_kit_id
       and tp.t_panel_id = kpm.t_panel_id
       and pqm.t_panel_id = tp.t_panel_id
       and tp.t_panel_id = i_tpanel_id
       and tq.t_question_id = pqm.t_question_id;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_add_scaffold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_add_scaffold`(IN i_kit_id BIGINT(20), IN i_tpanel_id BIGINT(20))
BEGIN
  declare v_status varchar(10);
  declare v_return varchar(255);
  declare i_panel_count int default 0;
  declare i_ques_count int default 0;
  declare i int;

  call ec_log_message('INFO', concat('ec_create_panels_and_questions(', i_tpanel_id, ', ', i_kit_id, ')'), 'Creating Panels/Questions');

  select status
    into v_status
    from ec_kits
   where kit_id = i_kit_id;

  
    insert 
      into ec_panels(
           t_panel_id,
           kit_id)
    select tp.t_panel_id,
           i_kit_id
      from ec_t_panels tp,
           ec_t_kits tk,
           ec_t_kits_t_panels_map kpm,
           ec_kits k
     where k.kit_id = i_kit_id
       and tk.t_kit_id = k.t_kit_id
       and kpm.t_kit_id = tk.t_kit_id
       and tp.t_panel_id = kpm.t_panel_id
       and tp.t_panel_id = i_tpanel_id;
  
    select row_count() into i_panel_count;

    if i_panel_count = 0 then
      SIGNAL SQLSTATE VALUE '45000'
        SET MESSAGE_TEXT = 'No panel templates were found for kits template';
    end if;

    insert
      into ec_questions(
           t_question_id,
           kit_id,
           `group`,
           sub_group,
           question,
           required,
           hidden,
           gender,
           data_type_id)
    select tq.t_question_id,
           i_kit_id,
           tq.group,
           tq.sub_group,
           tq.question,
           tq.required,
           tq.hidden,
           tq.gender,
           tq.data_type_id
      from ec_t_questions tq,
           ec_t_panels tp,
           ec_t_kits tk,
           ec_t_kits_t_panels_map kpm,
           ec_t_panels_t_questions_map pqm,
           ec_kits k
     where k.kit_id = i_kit_id
       and tk.t_kit_id = k.t_kit_id
       and kpm.t_kit_id = tk.t_kit_id
       and tp.t_panel_id = kpm.t_panel_id
       and pqm.t_panel_id = tp.t_panel_id
       and tp.t_panel_id = i_tpanel_id
       and tq.t_question_id = pqm.t_question_id
       and not exists(select 1 from ec_questions where kit_id = i_kit_id and t_question_id = tq.t_question_id);
    
    select row_count() into i_ques_count;

    select concat(i_panel_count,' panels added, ', i_ques_count, ' questions added') into v_return;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_add_scaffolds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_add_scaffolds`(IN i_kit_id BIGINT(20), IN v_panel_ids VARCHAR(255))
BEGIN
  declare i_new_kit_id int;
  declare i_tpanel_id int;
  declare v_new_panel_msg varchar(255);
  declare front text default null;
  declare frontlen int default null;
  declare tempvalue text default null;
  declare i int;
  
  declare exit handler for sqlexception
    begin
      rollback;
      GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
      call ec_log_message('ERROR', 'ec_create_kit()', concat(@p1,'|',@p2));
      resignal;
    end;

  select ec_randomBarcode(3) into @message_session;
  call ec_log_message('INFO', concat('ec_add_scaffolds(', i_kit_id, ', ', v_panel_ids, ')'), 'Adding Panels and Questions to Kit');

  start transaction;

  iterator:
  loop  
    if length(trim(v_panel_ids)) = 0 or v_panel_ids is null then
      leave iterator;
    end if;

    set front = substring_index(v_panel_ids,',',1);
    set frontlen = length(front);
    set tempvalue = trim(front);

    call ec_add_scaffold(i_kit_id, tempvalue);

    set v_panel_ids = insert(v_panel_ids,1,frontlen + 1,'');

  end loop;

  commit;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_create_kit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `ec_create_kit`(IN i_tkit_id BIGINT(20), IN i_partner_id BIGINT(20), IN v_ib_tracking_id VARCHAR(255), OUT i_new_kit_id BIGINT(20))
BEGIN
  declare n_finished int(1) default 0;
  declare i_tpanel_id int;
  declare v_new_panel_msg varchar(255);
  declare front text default null;
  declare frontlen int default null;
  declare tempvalue text default null;
  declare i int;
  declare b_add_panels bool;
  
  
  declare t_panel_cur cursor for
    select p.t_panel_id
      from ec_t_panels p,
           ec_t_kits_t_panels_map kpm
     where kpm.t_kit_id = i_tkit_id
       and p.t_panel_id = kpm.t_panel_id;
   
  
  declare continue handler for not found set n_finished = 1; 
  
  declare exit handler for sqlexception
    begin
      rollback;
      GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
      call ec_log_message('ERROR', 'call ec_create_kit()', concat(@p1,'|',@p2));
      resignal;
    end;

  select ec_randomBarcode(3) into @message_session;
  call ec_log_message('INFO', concat('call ec_create_kit(', i_tkit_id, ', ', i_partner_id, ', ', v_ib_tracking_id, ')'), 'Creating Kits');

  start transaction;
  select ec_create_kit(i_tkit_id, i_partner_id, v_ib_tracking_id) into i_new_kit_id;

  select add_panels
    into b_add_panels
    from ec_t_kits t
   where t.t_kit_id = i_tkit_id;

  if b_add_panels then
    set n_finished = 0;
    open t_panel_cur;
    insert_panels: loop
    fetch t_panel_cur into i_tpanel_id;
    
      if n_finished = 1 then
       leave insert_panels;
      end if;
  
      call ec_add_scaffold(i_new_kit_id, i_tpanel_id);
  
    end loop; 	
  	close t_panel_cur;  
  end if;

  call ec_log_message('INFO', concat('call ec_create_kit(', i_tkit_id, ', ', i_partner_id, ', ', v_ib_tracking_id, ')'), 'Completed Successfully');

  commit;

	select i_new_kit_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_create_requisition` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsuser`@`%` PROCEDURE `ec_create_requisition`(IN i_user_id BIGINT(20), IN v_kit_barcode VARCHAR(255), OUT n_new_req_id BIGINT(20))
BEGIN
  declare n_finished int(1) default 0;
  declare n_new_req_id int(20);
  declare i_kit_id bigint(20);
  declare i_tkit_id bigint(20);
  declare i_tmodule_id bigint(20);
  declare i_new_module bigint(20);
  declare v_gender varchar(6);
  declare i_submission_id int;
  declare b_demo bool;
  
  
  declare t_module_cur cursor for
    
    select tm.t_health_module_id
      from ec_t_health_modules tm,
           ec_t_kits tk,
           ec_t_health_modules_t_kits_map tkm
     where tk.t_kit_id = i_tkit_id
       and tkm.t_kit_id = tk.t_kit_id
       and tm.t_health_module_id = tkm.t_health_module_id
       and not exists(select 1 from ec_health_modules where user_id = i_user_id and t_health_module_id = tm.t_health_module_id);
   
  
  declare continue handler for not found set n_finished = 1; 
  declare exit handler for sqlexception
    begin
      rollback;
      GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
      call ec_log_message('ERROR', 'ec_create_requisition()', concat(@p1,'|',@p2));
      resignal;
    end;

  call ec_log_message('INFO', concat('ec_create_requisition(', i_user_id, ', ', v_kit_barcode, ')'), 'Creating Requisition');

  start transaction;    
	
  
  select kit_id,
         t_kit_id
    into i_kit_id,
         i_tkit_id
    from ec_kits k
   where k.barcode = v_kit_barcode
     and k.requisition_id is null;
     
  select p.demo
    into b_demo
    from ec_kits k,
		 ec_partners p
   where k.kit_id = i_kit_id
     and p.partner_id = k.partner_id;
   
  if b_demo then
    set i_submission_id = -999;
  end if;
   
  insert
    into ec_requisitions 
        (submission_id, 
         user_id,
         created_at, 
         updated_at)
  values(i_submission_id,
         i_user_id, 
         now(), 
         now());
    
	select last_insert_id() 
    into n_new_req_id;
    
  select gender
    into v_gender
    from ec_user_demographics
   where user_id = i_user_id;

  delete
    from ec_questions
   where kit_id = i_kit_id
     and gender != v_gender;

  update ec_kits k 
     set k.requisition_id = n_new_req_id,
         k.status = 'ALLOCATED',
         k.updated_at = now()
   where k.kit_id = i_kit_id;
  
  
  open t_module_cur;
    insert_modules: loop
    fetch t_module_cur into i_tmodule_id;
  
    if n_finished = 1 then
     leave insert_modules;
    end if;

    
    select ec_create_module(i_tmodule_id, i_user_id) into i_new_module;

  end loop; 	
	close t_module_cur;    
  
  insert
    into ec_health_modules_requisitions_map
        (health_module_id,
         requisition_id)
  select m.health_module_id,
         n_new_req_id
    from ec_t_health_modules tm,
         ec_t_kits tk,
         ec_t_health_modules_t_kits_map tkm,
         ec_health_modules m
   where tk.t_kit_id = i_tkit_id
     and tkm.t_kit_id = tk.t_kit_id
     and tm.t_health_module_id = tkm.t_health_module_id
     and m.t_health_module_id = tm.t_health_module_id
     and m.user_id = i_user_id;

  commit;

	select n_new_req_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_log_message` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_log_message`(IN v_level VARCHAR(10), IN v_source VARCHAR(255), IN v_message TEXT)
BEGIN
  insert 
    into ec_messages
        (session,
         level,
         source,
         message)
  values(@message_session,
         v_level,
         v_source,
         v_message);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_log_user_message` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_log_user_message`(IN i_user_id BIGINT(20), IN type_of VARCHAR(255), IN v_source VARCHAR(255), IN v_subject VARCHAR(255), IN t_body TEXT)
BEGIN
  insert 
    into ec_user_messages
        (user_id,
         type_of,
         source,
         subject,
         body)        
  values(i_user_id,
         type_of,
         v_source,
         v_subject,
         t_body);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_reset_kit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_reset_kit`(IN i_kit_id BIGINT(20))
BEGIN
  declare i_req_id bigint(20);
  declare i_user_id bigint(20);
  
  select requisition_id
    into i_req_id
    from ec_kits
   where kit_id = i_kit_id;
   
  select user_id
    into i_user_id
    from ec_requisitions
  where requisition_id = i_req_id;
  
  update ec_kits
     set status = 'LOGGED',
		 requisition_id = null
   where kit_id = i_kit_id;
  
  delete 
    from ec_panels
   where kit_id = i_kit_id;
   
  delete 
    from ec_questions
   where kit_id = i_kit_id;

  delete 
    from ec_health_modules_requisitions_map
   where requisition_id = i_req_id;
   
  delete
    from hm
   using ec_health_modules as hm
   where hm.user_id = i_user_id
	 and not exists(select 1 from ec_health_modules_requisitions_map where health_module_id = hm.health_module_id);
   
   delete 
    from ec_requisitions
   where requisition_id = i_req_id;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_setDailyCheckupStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_setDailyCheckupStatus`(
	in_account_id bigint
)
begin
  declare dt_latest_date date default null;
  declare n_answered_yes tinyint default 0;
  declare n_checkup_status tinyint default 0;
  declare n_kit_id bigint default null;
  
  declare n_question_count int default 0;
  declare n_question_null int default 0;
  declare n_question_temperature decimal(4,1) default 0;
  declare n_question_yes int default 0;
  
  
  
  select k.kit_id
    into n_kit_id 
    from ec_kits k,
         ec_requisitions r,
         accounts a
   where k.requisition_id = r.requisition_id
	 and r.user_id = a.user_id
	 and a.id = in_account_id
   order 
      by k.kit_id desc
   limit 1;
  
  
  select max(date(updated_at))
    into dt_latest_date 
    from ec_questions
   where kit_id = n_kit_id;
  
  
  
  
  if (n_kit_id is not null && dt_latest_date = curdate()) then
	  select  count(q.response),
			  sum( case when q.response is null then 1 else 0 end),
			  sum( case when q.response = 'Yes' then 1 else 0 end),					
			  sum( 
					case when q.question = 'Temperature' and q.response like '%C' then (cast(coalesce(q.response,0) as decimal(4,1)) * 9 / 5 + 32)
                         when q.question = 'Temperature'                          then  cast(coalesce(q.response,0) as decimal(4,1))
                         else 0.0
				    end
				  )		
		into  n_question_count, n_question_null, n_question_yes, n_question_temperature
	    from ec_questions q
	   where q.kit_id = n_kit_id
	     and data_type_id in (3,24) 
		 and date(q.updated_at) = dt_latest_date;     

	select n_question_temperature;

	if (n_question_yes > 0 or n_question_temperature >= 100.4) then
	  set n_checkup_status = 2;
    elseif (n_question_null < n_question_count) then
      set n_checkup_status = 1;
	end if;

  end if;
  
  insert into covid19_daily_checkups (account_id, checkup_date, daily_checkup_status_code) values (in_account_id, curdate(), n_checkup_status)
  on duplicate key update daily_checkup_status_code = n_checkup_status, updated_at = now();
  
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ec_summary_data_all` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `ec_summary_data_all`(i_hm_id bigint(20))
BEGIN
  declare v_result_json text;
  declare i_max_results integer;
  
  SET SESSION group_concat_max_len = (7 * 1024);

  set @blank = concat('{ \"blah\": ', '[{ ', '\"value\": \"\"},', '{ \"color\": \"\" },', '{ \"link1": \"\" },', '{ \"date\": \"\" }]}, ');
  set @sql = null;
  set @row_number = 0;   
	         
	select group_concat(xxx) from (         
		SELECT distinct GROUP_CONCAT(DISTINCT
			CONCAT(
				'MAX(CASE WHEN t.test_name = t.test_name ', 
				'AND t.test_id = (select t2.test_id 
								    from ec_tests t2 
								   where t2.kit_id in(select k.kit_id from ec_health_modules_requisitions_map m, ec_kits k where m.health_module_id = ', i_hm_id, ' and k.requisition_id = m.requisition_id)
								     and t2.test_name = t.test_name
							       order
								      by t2.result_date limit 1)',
				' THEN ',
				"concat('{ \"baseline\": ', '[{ ', '\"value\": \"', t.result, '\"},', 
					    '{ \"color\": \"', ec_report_color(t.z_score), '\" },', 
                        '{ \"link1\": \"/kits/', t.kit_id, '_Show Kit Detail', '\" },', 
                        '{ \"link2\": \"/reports/', t.kit_id, '_Show Report', '\" },', 
                        '{ \"date\": \"', date_format(t.result_date,\"%c/%e/%Y\"), '\" }]}, ')",
				'END)')) as xxx
		from ec_kits k,
			 ec_tests t
		 where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
		   and t.kit_id = k.kit_id
	   group
		  by t.test_name
       union
 	select replace(xxx, 'blah', (@row_number:=@row_number + 1)) as xxx from (
		SELECT GROUP_CONCAT(DISTINCT
				 CONCAT(
				   'ifnull(',
				   'MAX(CASE WHEN t.test_name = t.test_name ', 
				   'AND t.result_date = str_to_date(''', t.result_date, ''',''%Y-%m-%d'')',
				   ' THEN ',
				   "concat('{ \"blah\": ', '[{ ', '\"value\": \"', t.result, '\"},', 
						   '{ \"color\": \"', ec_report_color(t.z_score), '\" },', 
						   '{ \"link1\": \"/kits/', t.kit_id, '_Show Kit Detail', '\" },', 
                           '{ \"link2\": \"/reports/', t.kit_id, '_Show Report', '\" },', 
                           '{ \"date\": \"', date_format(t.result_date,\"%c/%e/%Y\"), '\" }]}, ')",
					'END)', ',''',
					concat('{ \"blah\": ', '[{ ', '\"value\": \"\"},', '{ \"color\": \"\" },', '{ \"link1": \"\" },', '{ \"date\": \"', date_format(t.result_date, "%c/%e/%Y") , '\" }]}, ')				
                    , ''')' )) as xxx
		from ec_kits k,
			 ec_tests t 
		 where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
		   and t.kit_id = k.kit_id
	   group
		  by t.result_date
	   order
          by t.result_date) f
		union
      select "concat('{ \"current\": ', '[{ ', '\"value\": \"', round((t.rr_min + t.rr_max)/2,2), '\"},', '{ \"color\": \"green\" },', '{ \"link1\": \" \" },', '{ \"date\": \" \" }]}, ')"
		from ec_kits k,
			 ec_tests t
		 where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = i_hm_id)
		   and t.kit_id = k.kit_id
	   group
		  by t.test_name
			  ) w
	into @sql;
  
  set @sql = 
    concat(
	 "select replace(x.js, ', <end>', ']}') from (select concat_ws('', '{ \"', t.test_name, '\": [',", @sql, ",'<end>') as js"
	 '  from ec_kits k,
			 ec_tests t
		 where k.requisition_id in(select requisition_id from ec_health_modules_requisitions_map where health_module_id = ', i_hm_id, ')
		   and t.kit_id = k.kit_id
	   group
		  by t.test_name) x'); 
	
    insert into admin_debug(level,message) values('INFO', @sql);
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;      

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `load_seeds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `load_seeds`(i_user_id integer)
BEGIN
	declare i_qty integer;
	declare v_barcode varchar(100);
    declare n_finished integer;
    
	declare t_kit_cur cursor for
		select barcode
		  from ec_kits;
	   
	 
	declare continue handler for not found set n_finished = 1; 
    
    set i_qty = 2;
	
	delete from ec_requisitions;
	delete from ec_questions;
	delete from ec_kits;
    
    call ec_create_kit(1, 1, i_qty);
    call ec_create_kit(2, 1, i_qty);
    call ec_create_kit(3, 1, i_qty);
    call ec_create_kit(4, 1, i_qty);
    call ec_create_kit(5, 1, i_qty);

	open t_kit_cur;
		insert_kits: loop
		  
		fetch t_kit_cur into v_barcode;

		if n_finished = 1 then
		 leave insert_kits;
		end if;

		call ec_create_req(i_user_id,v_barcode);
        
		end loop;   
          
	close t_kit_cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `minion_getKits` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `minion_getKits`()
begin
	select  	k.kit_id, k.barcode, k.inbound_tracking_id, k.updated_at, k.inbound_shipping_label,
				tk.name as kit_name,
				prt.name as partner_name, prt.type_of as partner_type,
                l.barcode_type, l.name as lab_name
           
	from  		ec_kits k, ec_partners prt, ec_t_kits tk, ec_labs l
    
	where    	k.partner_id = prt.partner_id
	and    		k.t_kit_id = tk.t_kit_id
	and    		tk.lab_id = l.lab_id
	and 		upper(k.status) = 'LOGGED'
	
    
    and         prt.partner_id = 19
    
	order by  	k.kit_id;
   
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `minion_updateKit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ehsadmin`@`%` PROCEDURE `minion_updateKit`(in_kit_id bigint(20))
begin
  update ec_kits 
  set status = 'PRINTED', updated_at = utc_timestamp() 
  where kit_id = in_kit_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('0'),
('20200415201257');


